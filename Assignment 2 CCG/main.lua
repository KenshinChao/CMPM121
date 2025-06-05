roundStartEffects = {}
roundEndEffects = {}

io.stdout:setvbuf("no")

require "cardClass"
require "game"
require "locationClass"
require "player"

draggedCard = nil
local inspectingCard = nil  -- Holds the card that is being inspected

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
local game = nil

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
    
    if not isTitleScreen and game then
      if x > submitButton.x and x < submitButton.x + submitButton.width and
         y > submitButton.y and y < submitButton.y + submitButton.height then
        if game.phase == "player" and game.winner == "" then
          print("game phase: PLAYER")
          game:playerSubmit()
        end
      end
    end

    -- Game screen: Card drag and drop
    if not isTitleScreen and game and game.phase == "player" and game.winner == "" then
      for _, card in ipairs(game.players[1].hand) do
        if x > card.x and x < card.x + 100 and y > card.y and y < card.y + 150 then
          draggedCard = card
          break
        end
      end
    end
    
    if not isTitleScreen and game and game.winner == "" then
      for _, card in ipairs(game.players[1].hand) do
        if x > card.x and x < card.x + 100 and y > card.y and y < card.y + 150 then
          inspectingCard = card  
          break
        end
      end
    end
    
    if not inspectingCard and game then 
        for locationIndex, location in ipairs(game.locations) do
          for _, card in ipairs(game.players[1].stagedPlays[locationIndex] or {}) do
            if not card.flipped and x > card.x and x < card.x + 100 and y > card.y and y < card.y + 150 then
              inspectingCard = card  
              break
            end
          end
          
          for _, card in ipairs(game.players[2].stagedPlays[locationIndex] or {}) do
            if not card.flipped and x > card.x and x < card.x + 100 and y > card.y and y < card.y + 150 then
              inspectingCard = card (enlarged)
              break
            end
          end
          
          
          if inspectingCard then break end
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
  if inspectingCard then
    inspectingCard = nil
  end
  
end

function love.draw()
  love.graphics.clear(1, 1, 1)  -- RGB for white background
  
  if isTitleScreen then
    -- Title Screen
    local prevFont = love.graphics.getFont()  
    love.graphics.setFont(love.graphics.newFont(40)) 
    love.graphics.setColor(0, 0, 0)  
    love.graphics.printf("Marvelous Snap", 0, 200, 960, "center")
    love.graphics.setFont(prevFont)  

    -- Start Game button
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

    -- Display the inspected card (enlarged version)
    if inspectingCard then
      local cardWidth, cardHeight = 200, 300  -- Enlarged card size

      -- Draw a semi-transparent background for inspection mode
      love.graphics.setColor(0, 0, 0, 0.7)
      love.graphics.rectangle("fill", 100, 300, 760, 300, 12, 12)  -- Background for inspection

      -- Set text color and draw card details
      love.graphics.setColor(1, 1, 1)
      love.graphics.setFont(love.graphics.newFont(24))
      love.graphics.printf("Inspecting: " .. inspectingCard.name, 100, 320, 760, "center")

      love.graphics.setFont(love.graphics.newFont(18))
      love.graphics.printf("Cost: " .. inspectingCard.cost, 100, 360, 760, "center")
      love.graphics.printf("Power: " .. inspectingCard.power, 100, 390, 760, "center")
      love.graphics.printf("Description: " .. inspectingCard.text, 100, 420, 760, "center")

      -- Optionally add a close button
      love.graphics.setColor(0.8, 0.2, 0.2)  -- Red close button
      love.graphics.rectangle("fill", 850, 350, 100, 50, 10)
      love.graphics.setColor(1, 1, 1)
      love.graphics.printf("Close", 850, 375, 100, "center")

      -- Check if player clicks the close button
      local mx, my = love.mouse.getPosition()
      if love.mousepressed then
        if mx > 850 and mx < 950 and my > 350 and my < 400 then
          inspectingCard = nil  -- Close the inspection when the close button is clicked
        end
      end
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
