TestClass = {}

function CircleClass:new(xPos, yPos, rad) --making a function called new
    local circleClass = {}
    
    setmetatable(circleClass, {__index=  TestClass})
    circleClass.position = {x = xPos, y = yPos}
    circleClass.radius = rad
    return circleClass
    
  
end

function circleClass:draw() --semi colon will pass self. otherwise you'll need TestClass.draw(self,...)
    --TODO: draw it
  
  end