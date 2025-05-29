Game = {}
require("player")

GamePhases = {
  PLAYER = "player",
  AI = "ai",
  INTERMISSION = "intermission",
  REVEAL = "reveal",
  END = "end",
  GAMEOVER = "player"
}

function Game:new(p1, p2)
  local game = {}
  local metadata = {__index = Game}
  setmetatable(game,metadata)
  game.phase = "player" 
  game.turn = 1
  game.maxPoints = 25
  game.players = {p1, p2}
  game.locations = {
    Location:new("Crimson Valley"),
    Location:new("Sky Temple"),
    Location:new("Void Nexus")
  }
  game.winner = ""
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
      if card.effectActivated == false then
      card.flipped = true
      end
    end
  end

  
  self.phase = GamePhases.AI
  
end

function Game:aiSubmit()
  print("ai submits")
  local ai = self.players[2]

  -- Filter cards affordable by current mana
  local affordableCards = {}
  for _, card in ipairs(ai.hand) do
    if card.cost <= ai.mana then
      table.insert(affordableCards, card)
    end
  end

  -- If no affordable card, AI skips turn
  if #affordableCards == 0 then
    print("AI cannot afford any cards")
    self.phase = GamePhases.INTERMISSION
    return
  end

  -- Pick random affordable card
  local chosen = affordableCards[math.random(#affordableCards)]

  -- Pick random location (1 to 3)
  local locationIndex = math.random(1, #self.locations)

  chosen.flipped = true
  ai:stageCard(locationIndex, chosen)

  -- Remove chosen card from hand
  for i, c in ipairs(ai.hand) do
    if c == chosen then
      table.remove(ai.hand, i)
      break
    end
  end

  print("AI staged card:", chosen.name, "to location", locationIndex)
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
  if self.phase == GamePhases.INTERMISSION then
    self.timer = self.timer + dt
    if self.timer > 1.5 then  
      self.phase = GamePhases.REVEAL
      self.timer = 0
      self:RevealStage()  -- Flip cards now
    end

  elseif self.phase == GamePhases.AI then
    self.timer = self.timer + dt
    if self.timer > 2 then  
      self:aiSubmit()
      self.phase = GamePhases.INTERMISSION
      self.timer = 0
    end

  elseif self.phase == GamePhases.REVEAL then
    self.timer = self.timer + dt
    if self.timer > 2.5 then  
      self:scorePoints()
      self:endOfTurnEffects()    
      self:checkWin()
      self.turn = self.turn + 1

      for _, player in ipairs(self.players) do
        player:drawCard()
        player.mana = self.turn
      end

      self.phase = GamePhases.END  
      self.timer = 0
    end

elseif self.phase == GamePhases.END then
    if self:checkWin() == false then
    self.timer = self.timer + dt
    if self.timer > 2 then 
    
      self.phase = GamePhases.PLAYER  
      self.timer = 0
    end
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

    --self.players[1].stagedPlays[i] = {}
    --self.players[2].stagedPlays[i] = {}
  end
end

function Game:revealAllCards()
  print("revealing all cards")
  for i = 1, 3 do
    for _, card in ipairs(self.players[1].stagedPlays[i]) do
      if card.flipped == true then
        card.flipped = false
        if card.onReveal and not card.effectActivated then
          card:onReveal(self, 1, i)  -- game, playerIndex=1, locationIndex=i
          card.effectActivated = true
        end
      end
    end
    for _, card in ipairs(self.players[2].stagedPlays[i]) do
      if card.flipped == true then
        card.flipped = false
        if card.onReveal and not card.effectActivated then
          card:onReveal(self, 2, i)  -- game, playerIndex=2, locationIndex=i
          card.effectActivated = true
        end
      end
    end
  end
end

function Game:endOfTurnEffects()
  for playerIndex, player in ipairs(self.players) do
    for locationIndex, stagedCards in ipairs(player.stagedPlays) do
      for _, card in ipairs(stagedCards) do
        if card.onEndTurn then
          card:onEndTurn(self, playerIndex, locationIndex)
        end
      end
    end
  end
end

function Game:draw()
  love.graphics.setColor(0, 0, 0)
  
  love.graphics.print("Marvelous Snap", 400, 10, 0, 2, 2)
  
  if self.phase == GamePhases.PLAYER then
     love.graphics.print("Your Turn", 700, 800, 0, 2, 2)
    elseif self.phase == GamePhases.AI then
     love.graphics.print("AI placing...", 700, 800, 0, 2, 2)
  
    elseif self.phase == GamePhases.INTERMISSION then
     love.graphics.print("INTERMISSION", 700, 800, 0, 2, 2)
  
    elseif self.phase == GamePhases.REVEAL then
     love.graphics.print("REVEALING", 700, 800, 0, 2, 2)
  
    elseif self.phase == GamePhases.END then
     love.graphics.print("ENDING TURN", 700, 800, 0, 2, 2)
    
    elseif self.phase == GamePhases.GAMEOVER then
      print("GAME OVER")
    local winnerMessage = self.winner .. "wins!"
    
    love.graphics.setColor(1, 0, 0)  
    local prevFont = love.graphics.getFont()
    love.graphics.setFont(love.graphics.newFont(50)) 
    love.graphics.printf(winnerMessage, 0, love.graphics.getHeight() / 2 - 25,  love.graphics.getWidth(), "center")
     love.graphics.setFont(prevFont)
  end
  for i, player in ipairs(self.players) do
    player:drawHand(i)
    player:drawDiscardPile(i)
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
    local winner
    if p1 > p2 then
      self.winner = tostring(self.players[1].name)
      print(self.players[1].name .. " wins the game!")
    elseif p2 > p1 then
      self.winner = tostring(self.players[2].name)
      print(self.players[2].name .. " wins the game!")
    else
      winner = "It's a tie"
      print("It's a tie!")
    end

   
    self.phase = GamePhases.GAMEOVER
    return true
    
  end
  return false
end

function Game:restart()
  self.winner = ""
  self.phase = GamePhases.PLAYER
  self.turn = 1
  self.players[1].points = 0
  self.players[2].points = 0
  self.players[1].mana = self.turn
  self.players[2].mana = self.turn


  self.players[1].hand = {}
  self.players[2].hand = {}
  self.players[1].discard = {}
  self.players[2].discard = {}
  self.players[1].stagedPlays = {}
  self.players[2].stagedPlays = {}

  for _, player in ipairs(self.players) do
    player.deck = player:generateDeck()  
    for _ = 1, 3 do
      player:drawCard()
    end
  end

  -- Start the first turn
  self:startTurn()
end
