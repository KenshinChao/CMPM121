--Kenshin Chao & Joshua Acosta  
--Discussion Section 1

--Recreate a game where balls bounce on the walls and depending on the length the user pulled back, increase speed. As balls bounce the shape shrinks. Balls are also different color every time a mouse clicked.

io.stdout:setvbuf("no") --print statements in real time

	local windowWidth, windowHeight = love.graphics.getDimensions()
local world = love.physics.newWorld(0, 9.8, true)
local circlebody = love.physics.newBody(world, windowHeight/2, windowWidth/2, "dynamic")
local circleshape = love.physics.newCircleShape(20) 
local circlefixture = love.physics.newFixture(circlebody,circleshape,1)
local bounciness = circlefixture:setRestitution(0.9)


oldx, oldy = 0,0
function love.update(dt)
  world:update(dt)
if (love.mouse.isDown(1)) then
  
  else 
  oldx,oldy = love.mouse.getPosition()
  
end


end

function love.draw()
  love.graphics.circle("line", circlebody:getX(),
                       circlebody:getY(), circleshape:getRadius())
  

  -- set the drawing color to grey for the blocks
  if (love.mouse.isDown(1)) then
  local mx, my = love.mouse.getPosition()

	local windowWidth, windowHeight = love.graphics.getDimensions()

	love.graphics.line(oldx, oldy, mx, my)
  debounce = true
else 
--love.graphics.circle("line", oldx,oldy, 4)
end

  
end