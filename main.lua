require "button"
require "ShopRite"
require "iSpy"
require "wario"
require "racing"



color = {0,0,0,1}
function love.load()
	love.window.setMode( 800, 600, {resizable = false, centered=true, minwidth=800, minheight=600} )
	if currFrame == "ShopRite" then makeNumbersAndBlocks() end
	
end


function love.update(dt)
	if currFrame == "ShopRite" then 
		if updateBlock() then createButton() end
	end
	if currFrame == "iSpy" then 
		makeiSpy() 
		checkBoxes()
		if checkValues() then 
			createButton() 
		end
	end

	if currFrame == "wario" then 
		if updateClothes() then createButton() end
	end

	if currFrame == "racing2" then 
		if updateRacing() then createButton() end
	end
	--love.timer.sleep(.5)
end


function love.draw()
	love.graphics.setBackgroundColor(unpack(color))
	if currFrame == "ShopRite" then drawBlock() end
	if currFrame == "iSpy" then drawiSpy() end
	if currFrame == "wario" then drawWario() end
	if currFrame == "racing2" then drawRacing()  end
	drawButtons()
end


function love.mousepressed(x, y, button)
	if currFrame == "ShopRite" then pickNumber(x,y, button) end

	if currFrame == "iSpy" then
		TF,i = checkBoxes(x,y, button) 
		if TF and button == 1 then
			values[i] = 0
			print("found it")
		end
	end

	if currFrame == "wario" then pickClothes(x,y,button) end
	--print(x,y)
end

function love.mousereleased(x, y, button)
	if currFrame == "ShopRite" then dropBlock(x,y,button) end
	if currFrame == "wario" then  dropClothes(x,y,button) end
	checkButton(x,y, button)
	
end

function releaseOver(mx, my, a, arr)
	for i=1, table.getn(arr) do
	if mx >= a.x and mx <= a.x + a.w then
	    if my >= a.y and my < a.y + a.h then
	        return true
	    end
	end
	end
end

function love.keypressed( key )
	if key == "q" then 
		print("Quitting")
		love.event.quit "" 
	end

end






