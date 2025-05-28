Game = {}


GamePhases = {
  PLAYER = "player",
  AI = "ai",
  INTERMISSION = "intermission",
  REVEAL = "reveal",
  END = "end"
}

function Game:new(p1, p2)
  local game = {}
  local metadata = {__index = Game}
  setmetatable(game,metadata)
  game.phase = "player" 
  game.turn = 1
  game.maxPoints = 20
  game.players = {p1, p2}
  game.locations = {
    Location:new("Crimson Valley"),
    Location:new("Sky Temple"),
    Location:new("Void Nexus")
  }
  game.timer = 0
  return game
end



function Game:startTurn()
  print("=== Turn " .. self.turn .. " ===")
  for _, player in ipairs(self.players) do
    player:drawCard()
  end
end

function Game:playerSubmit()
  -- Flip player cards face-down
  for i = 1, 3 do
    for _, card in ipairs(self.players[1].stagedPlays[i]) do
      card.flipped = true
    end
  end

  -- Proceed to AI phase
  self.phase = GamePhases.AI
  
end

function Game:aiSubmit()
  print("ai submits")
  local chosen = self.players[2].hand[1]

  if not chosen then return end -- fail safe

  chosen.flipped = true
  self.players[2].mana = self.players[2].mana - chosen.cost 
  self.players[2]:stageCard(1, chosen)
  print("AI staged card:", chosen.name, "to location 1")
  for i, c in ipairs(self.players[2].hand) do
    if c == chosen then
      table.remove(self.players[2].hand, i)
      break
    end
  end
  print("end of ai turn")
  self.phase = GamePhases.INTERMISSION
  
end

function Game:RevealStage()
  if self.phase == GamePhases.REVEAL then
    self:revealAllCards()
    print("Cards revealed")
  end
end

function Game:update(dt)
  if self.phase == "intermission" then
    self.timer = self.timer + dt
    if self.timer > 1.5 then  -- intermission lasts 1.5 seconds
      self.phase = "reveal"
      self.timer = 0
      self:RevealStage()  -- flip cards now
    end
  elseif self.phase == "ai" then
    self.timer = self.timer + dt
    if self.timer > 2 then  -- intermission lasts 1.5 seconds
      self:aiSubmit()
      self.phase = "intermission"
      self.timer = 0
  end
  
  elseif self.phase == "reveal" then
    self.timer = self.timer + dt
    if self.timer > 3 then  -- allow 2 seconds to see revealed cards
      self:scorePoints()
      self:checkWin()
      self.turn = self.turn + 1

      for _, player in ipairs(self.players) do
        player:drawCard()
        player.mana = self.turn
      end

      self.phase = "player"
      self.timer = 0
    end
  end
end

function Game:scorePoints()
  print("Tallying up points for this round...")
  for i, loc in ipairs(self.locations) do
    local p1Plays = self.players[1].stagedPlays[i]
    local p2Plays = self.players[2].stagedPlays[i]
    local power1, power2 = loc:resolveTurn(p1Plays, p2Plays)

    local diff = math.abs(power1 - power2)
    local locationName = loc.name

    if power1 > power2 then
      self.players[1].points = self.players[1].points + diff
      print("Location: " .. locationName .. " - Player 1 (" .. self.players[1].name .. ") wins by " .. diff .. " points")
    elseif power2 > power1 then
      self.players[2].points = self.players[2].points + diff
      print("Location: " .. locationName .. " - Player 2 (" .. self.players[2].name .. ") wins by " .. diff .. " points")
    else
      print("Location: " .. locationName .. " - It's a tie!")
    end

    self.players[1].stagedPlays[i] = {}
    self.players[2].stagedPlays[i] = {}
  end
end

function Game:revealAllCards()
  print("revealing all cards")
  for i = 1, 3 do
    for _, card in ipairs(self.players[1].stagedPlays[i]) do
      card.flipped = false
    end
    for _, card in ipairs(self.players[2].stagedPlays[i]) do
      card.flipped = false
    end
  end
end



function Game:draw()
  love.graphics.setColor(0, 0, 0)
  
  love.graphics.print("Marvelous Snap", 400, 10, 0, 2, 2)
  
  if self.phase == GamePhases.PLAYER then
     love.graphics.print("Place your cards!", 700, 800, 0, 2, 2)
  end
    if self.phase == GamePhases.AI then
     love.graphics.print("AI placing...", 700, 800, 0, 2, 2)
  end
    if self.phase == GamePhases.INTERMISSION then
     love.graphics.print("INTERMISSION", 700, 800, 0, 2, 2)
  end
    if self.phase == GamePhases.REVEAL then
     love.graphics.print("REVEALING", 700, 800, 0, 2, 2)
  end
  
  for i, player in ipairs(self.players) do
    player:drawHand(i)
  end
  
  for i, player in ipairs(self.players) do
    local labelY = (i == 1) and 650 or 40
    local labelX = love.graphics.getWidth() - 180
    love.graphics.setColor(0, 0, 0)
    love.graphics.printf(
      player.name .. ": Points: " .. player.points .. "  Mana: " .. player.mana,
      labelX, labelY, 160, "right"
    )
  end
  for i, loc in ipairs(self.locations) do
  loc:draw(i, self.players[1].stagedPlays[i], self.players[2].stagedPlays[i])
end

end
function Game:checkWin()
  local p1 = self.players[1].points
  local p2 = self.players[2].points
  if p1 >= self.maxPoints or p2 >= self.maxPoints then
    if p1 == p2 then
      print("Tie at threshold! Checking final scores...")
    end
    local winner = (p1 > p2) and self.players[1].name or self.players[2].name
    print(winner .. " wins the game!")
    os.exit()
  end
end
