TestClass = {}

function TestClass:new(xPos, yPos, rot) --making a function called new
    local testClass = {}
    
    setmetatable(testClass, {__index=  TestClass})
    testClass.position = {x = xPos, y = yPos}
    testClass.rotation = rot
    return testClass
    
  
end

function TestClass:draw() --semi colon will pass self. otherwise you'll need TestClass.draw(self,...)
    --TODO: draw it
  
  end