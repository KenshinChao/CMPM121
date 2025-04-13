--Kenshin Chao
--CMPM 121 - Day 3 Demo
 --4-4-2025
io.stdout:setvbuf("no") --print statements in real time

require "testClass" --gets testClass.lua in reference. Doesn't need .lua

table = {}

function love.load()
  print("Game Loaded")
  --if no local then its considered global.
  local indexedTable = {
    [1] = "A",
    [2] = "B",
    [3] = "C"
  } 
  
  for k,v in ipairs(indexedTable) do
      print(tostring(k) .. " - " .. tostring(v))
  end
  
  local noIndexTable = { "A", "B", "C", "D" }
  for k,v in ipairs(noIndexTable) do 
    print(tostring(k) .. " -- " .. tostring(v))
  end
  
  --don't do this V
  local messTable = {
      [1] = "A", 
      ["diet"] = "B",
      [false] = "C",
      [4.2] = "D",
      [{x,y}] = "E",
      ["F"] = nil
    }
--i pairs means incremental pairs, 1,2,3,... so its random.
  for k,v in pairs(messTable) do
    print(tostring(k) .. " - " .. tostring(v))
  end
  function love.update(dt)
    if love.keyboard.isDown("w","a" , "s", "d") then
      print("Pressed")
      local testObj = TestClass:new(100,150,0)
      table.insert(testObjects, testObj)
  end
end


function love.draw()
  for _,obj in ipairs(testObjects) do
    obj:draw()
  end
  


end