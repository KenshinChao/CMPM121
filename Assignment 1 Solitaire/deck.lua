
require "vector"
require "grabber"
require "cardClass"

DeckClass = {}

DECK_STATE = {
  IDLE = 0,
  MOUSE_OVER = 1,
  GRABBED = 2
}

function DeckClass:new(xPos, yPos)
  local deck = {
    cards = {}
  }
  local metadata = {__index = DeckClass,
    __tostring = function(self)
      for _,card in pairs(deck.cards) do
        print(card)
      end
      
    return "Deck with " .. tostring(#self.cards) .. " cards"
  end
}


  setmetatable(deck, metadata)
  deck.cards = deck:generateDeck()
  deck:shuffleDeck()
  deck.image = love.graphics.newImage("images/Back Blue 1.png")
  deck.position = Vector(xPos, yPos)
  deck.size = Vector(50, 70)
  deck.state = DECK_STATE.IDLE
  deck.isDraggable = false
  return deck
end


function DeckClass:draw()
  love.graphics.draw(self.image, self.position.x, self.position.y, 0, 1/2, 1/2)
    love.graphics.print(tostring(self.state), self.position.x + 20, self.position.y - 20)
  
end


function DeckClass:checkForMouseOver(grabber)
  if self.state == DECK_STATE.GRABBED then
    return
  end
    
  local mousePos = grabber.currentMousePos
  local isMouseOver = 
    mousePos.x > self.position.x and
    mousePos.x < self.position.x + self.size.x and
    mousePos.y > self.position.y and
    mousePos.y < self.position.y + self.size.y
  
  self.state = isMouseOver and DECK_STATE.MOUSE_OVER or DECK_STATE.IDLE
end


function DeckClass:update()
  
end


function DeckClass:drawThreeCards(drawPile)
  --print(self)
  
  --print("after shuffle")
  --print(self)
  if #drawPile.cards > 0 then
    for _, card in ipairs(drawPile.cards) do
      table.insert(self.cards, card) -- Add the card back to the deck
      
    end
    drawPile.cards = {}
  end
  
  self:shuffleDeck()
  for i = 1, 3 do
    if #self.cards == 0 then break end
    
    table.insert(drawPile.cards, table.remove(self.cards)) -- take from end of deck
  end
  print("finished draw 3 function" .. #drawPile)
  return drawPile
end

function DeckClass:generateDeck()
  local deck = {}
  local suits = {"Spades", "Hearts", "Clubs", "Diamond"}
  local colors = {
    Spades = "black",
    Clubs = "black",
    Hearts = "red",
    Diamond = "red"
  }

  for _, suit in ipairs(suits) do
    for value = 1, 13 do
      table.insert(deck, CardClass:new(0, 0, colors[suit], suit, value, false, false))
    end
  end

  return deck
end

--[[
function DeckClass:shuffleDeck()
      print(#self.cards .. "number of cards")
  for i = #self.cards, 2, -1 do

    local j = love.math.random(i)
    self.cards[i], self.cards[j] = self.cards[j],self.cards[i]
  end
end--]]

function DeckClass:shuffleDeck()
	local cardCount = #self.cards
	for i = 1, cardCount do
		local randIndex = math.random(cardCount)
local temp = self.cards[randIndex]
self.cards[randIndex] = self.cards[cardCount]
self.cards[cardCount] = temp
cardCount = cardCount - 1
	end
	return deck
end
