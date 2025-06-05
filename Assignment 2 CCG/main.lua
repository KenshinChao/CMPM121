roundStartEffects = {}
roundEndEffects = {}

io.stdout:setvbuf("no")

require "cardClass"
require "game"
require "locationClass"
require "player"

draggedCard = nil

-- Define buttons
submitButton = {
  x = 700,
  y = 700,
  width = 200,
  height = 50,
  text = "Submit Turn"
}

startButton = {
  x = 380,
  y = 500,
  width = 200,
  height = 50,
  text = "Start Game"
}

local json = require("dkjson")

-- Game state flag
local isTitleScreen = true
local game

function love.load()
  math.randomseed(os.time())
  love.window.setMode(960, 960)
  love.window.setTitle("Marvelous Snap")
end

function love.update(dt)
  if game and game.update then
    game:update(dt)
  end
end

function love.mousepressed(x, y, button)
  if button == 1 then
    -- Title Screen: Start Game button click
    if isTitleScreen then
      if x > startButton.x and x < startButton.x + startButton.width and
         y > startButton.y and y < startButton.y + startButton.height then
        startGame()
      end
    end

    -- Game screen: Submit button click
    if not isTitleScreen then
      if x > submitButton.x and x < submitButton.x + submitButton.width and
         y > submitButton.y and y < submitButton.y + submitButton.height then
        if game.phase == "player" and game.winner == "" then
          print("game phase: PLAYER")
          game:playerSubmit()
        end
      end
    end

    -- Game screen: Card drag and drop
    if not isTitleScreen and game.phase == "player" and game.winner == "" then
      for _, card in ipairs(game.players[1].hand) do
        if x > card.x and x < card.x + 100 and y > card.y and y < card.y + 150 then
          draggedCard = card
          break
        end
      end
    end
  end
end

function love.mousereleased(x, y, button)
  if button == 1 and draggedCard and not isTitleScreen then
    for i, location in ipairs(game.locations) do
      if location:isInside(x, y) and draggedCard.cost <= game.players[1].mana then
        game.players[1]:stageCard(i, draggedCard)
        break
      end
    end
    draggedCard = nil
  end
end

function love.mousemoved(x, y, dx, dy)
  if draggedCard then
    draggedCard.x = x - 35
    draggedCard.y = y - 50
  end
end

function love.draw()
  love.graphics.clear(1, 1, 1)  
  
  if isTitleScreen then
    -- Title Screen
    local prevFont = love.graphics.getFont()  
    love.graphics.setFont(love.graphics.newFont(40)) 
    love.graphics.setColor(0, 0, 0)  
    love.graphics.printf("Marvelous Snap", 0, 200, 960, "center")
    love.graphics.setFont(prevFont)  

   --play button
    love.graphics.setColor(0.2, 0.6, 0.9)
    love.graphics.rectangle("fill", startButton.x, startButton.y, startButton.width, startButton.height, 10)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf(startButton.text, startButton.x, startButton.y + 15, startButton.width, "center")

  else
    
    local prevFont = love.graphics.getFont() 
    love.graphics.setFont(love.graphics.newFont(20))
    love.graphics.setColor(0, 0, 0) 

    -- Submit button
    love.graphics.setColor(0.2, 0.6, 0.9)
    love.graphics.rectangle("fill", submitButton.x, submitButton.y, submitButton.width, submitButton.height, 10)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf(submitButton.text, submitButton.x, submitButton.y + 15, submitButton.width, "center")
    
    -- Game content (draw game state)
    game:draw()

    -- Winner message
    if game.winner ~= "" then
      local winnerMessage = game.winner .. " wins!"
      love.graphics.setColor(1, 0, 0)  -- Red text
      love.graphics.setFont(love.graphics.newFont(20))  -- Font for winner message
      love.graphics.print(winnerMessage, 480, 480, 0, 2, 2)
      love.graphics.print("Press 'r' to restart!", 420, 520, 0, 2, 2)
      love.graphics.setFont(prevFont)  -- Restore the original font after winner message

      if love.keyboard.isDown("r") then
        game:restart()
      end
    end

    -- Draw dragged card if present
    if draggedCard then
      draggedCard:draw()
    end
  end
end

-- Start the game
function startGame()
  local p1 = Player:new("You")
  local p2 = Player:new("AI")
  game = Game:new(p1, p2)
  p1.mana = 1
  p2.mana = 1
  game:startTurn()
  
  isTitleScreen = false  -- Switch to game screen
end
