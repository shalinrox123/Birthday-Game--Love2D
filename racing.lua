require "camera"
local width = love.graphics.getWidth()
	local height = love.graphics.getHeight()


carImage=love.graphics.newImage('car.png')
car = {
	name= "car.png",
	x=width/2, 
	y=height/2, 
	w=carImage:getWidth( ), 
	h=carImage:getHeight( )
}

angle = 0
frame = 0
function drawRacing()

	camera:set()
	z=love.graphics.newImage('room.png')
	love.graphics.draw(z,0,0)
	-- -- rotate around the center of the screen by angle radians
	-- love.graphics.translate(width/2, height/2)
	-- love.graphics.rotate(angle) --THIS IS WHERE THE DIRECTION OF THE ANGLE CHANGES
	-- love.graphics.translate(-width/2, -height/2)
	-- -- draw a white rectangle slightly off center
	-- love.graphics.setColor(0xff, 0xff, 0xff)
	-- love.graphics.rectangle('fill', width/2-100, height/2-100, 300, 400)
	-- -- draw a five-pixel-wide blue point at the center
	-- love.graphics.setPointSize(5)
	-- love.graphics.setColor(0, 0, 0xff)
	

	love.graphics.draw(carImage, car.x, car.y, angle ,.5,.5, car.w, car.h)
	--love.graphics.rectangle('fill', car.x, car.y,car.w, car.h)
	-- camera:setPosition(0,car.y - height/2)
	camera:unset()
	--love.graphics.points(width/2, height/2)
end



function updateRacing( )
	

	if love.keyboard.isDown( "left" ) then 
		angle = angle +  math.pi/100
		angle = angle % (2*math.pi)
	elseif love.keyboard.isDown( "right" ) then
		angle = angle -  math.pi/100
		angle = angle % (2*math.pi)
	end
	if love.keyboard.isDown( "down" ) then
		--car.y = car.y + 10
		--car.x = car.x - 10
		turnX = math.sin(math.rad(angle)) * 100
		turnY = math.cos(math.rad(angle)) * 100
		print(turnX)
		--car.x = car.x - turnX
		--car.y = car.x + turnY
	elseif love.keyboard.isDown( "up" ) then
		car.y = car.y - 10
		--car.x = car.x + 10
	end

	print(angle)


end