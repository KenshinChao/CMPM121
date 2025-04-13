require "vector"

EntityClass = {}

SPRITE_SIZE = 16
SPRINT_SCALE = 4
inputVector = {
    ["w"] = Vector(0, -1),
    ["a"] = Vector(-1, 0),
    ["s"] = Vector(0, 1),
    ["d"] = Vector(1, 0)
}

DIRECTIONS = {
  UP = 1,
  DOWN = 2,
  LEFT = 3,
  RIGHT = 4
}


function EntityClass:new(xPos, yPos, width, height, scale)
  local entity = {}
  local metatable = {__index = EntityClass}
  setmetatable(entity, metatable)
  
  entity.sprite = love.graphics.newImage("Sprites/LinkDown.png")
  
  entity.directionSprites = {
    [DIRECTIONS.UP] = {
      {sprite = love.graphics.newImage("Sprites/LinkUp.png"), flipX = false}, --frame 1 
      {sprite = love.graphics.newImage("Sprites/LinkUp.png"), flipX = true}  --frame 2
    
    },
    [DIRECTIONS.DOWN] = {},
    [DIRECTIONS.LEFT] = {},
    [DIRECTIONS.RIGHT] = {}
  }
  

  entity.facingDirection = DIRECTIONS.DOWN
  entity.position = Vector(xPos,yPos)
  entity.size = Vector(width, height) * SPRITE_SIZE
  entity.scale = SPRINT_SCALE * (scale == nil and 1 or scale) --if scale is nill, multiply by 1 else then use scale
  return entity
end

function EntityClass:update()
  local moveDirection = Vector(0,0)
  
  for input, direction in pairs(inputVector) do
      if love.keyboard.isDown(input) then 
        moveDirection = moveDirection + direction 
      end
  end
  
  self.position = self.position + moveDirection
    
end

  
  function EntityClass:draw() --doesn't need to be called draw.
    love.graphics.rectangle("fill", self.position.x, self.position.y, self.size.x, self.size.y)
    love.graphics.draw(self.sprite, self.position.x, self.position.y, 0, self.scale, self.scale)
  end


  

  