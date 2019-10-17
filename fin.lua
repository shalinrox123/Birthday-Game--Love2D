

bedVal = 0
local play = 0
function playFire( f )
	f:setVolume(0.7)
	f:isLooping(true)
	f:play()
end
function drawFin( ... )
	collectgarbage()
	if play == 0 then
		fire = love.audio.newSource("sound/fire.wav", "queue")
		playFire(fire)
		play = 1
	end
	love.graphics.draw(love.graphics.newImage("fire/bed"..bedVal..".png"),0,0)
	bedVal = bedVal + 1
	if bedVal == 4 then bedVal = 1 end
	love.timer.sleep(.1)
	local text = "HAPPY BIRTHDAY ON THE BED!"
	font = love.graphics.setNewFont("font.ttf", 20)
	--local screenWidth, screenHeight = love.window.getDimensions()
	--love.graphics.printf(text,0,0,w)
	love.graphics.printf(text, 0, (600)*(4/5) - font:getHeight() / 2, 800, "center")
	
	
end