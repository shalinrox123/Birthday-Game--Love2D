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

-- ////////////////
-- require "camera"
-- local width = love.graphics.getWidth()
-- local height = love.graphics.getHeight()

-- Car = {}
-- Car.x = width/2 
-- Car.y = height/2 
-- Car.speed = 2
-- Car.angle = 0
-- Car.n = 0

-- Cars = {}

-- carImage=love.graphics.newImage('car.png')
-- car = {
-- 	name= "car.png",
-- 	x=width/2, 
-- 	y=height/2, 
-- 	w=carImage:getWidth( )/2, 
-- 	h=carImage:getHeight( )/2
-- }


-- function move( arr )
-- 	arr.x = arr.x + (math.sin(arr.angle) * arr.speed)
-- 	arr.y = arr.y - (math.cos(arr.angle) * arr.speed)
-- end


-- 	speedBuff = 0
-- 	angleBuff = 0
-- 	maxSpeed = 8.0
-- 	acc = .3
-- 	dec = .3
-- 	turnSpeed = .08
-- 	offsetX = 0
-- 	offsetY = 0

-- 	Up = false
-- 	Right = false
-- 	Down = false
-- 	Left = false

-- function drawRacing()

-- 	--print(Cars[1].x, Cars[1].y, Cars[1].speed, Cars[1].angle)
-- 	camera:set()
-- 	z=love.graphics.newImage('room.png')
-- 	love.graphics.draw(z,0,0)

-- 	love.graphics.draw(carImage, Cars[1].x, Cars[1].y, Cars[1].angle ,1,1, car.w, car.h)
-- 	camera:unset()
-- end

-- function updateRacing( )
-- 	speedBuff = 0
-- 	angleBuff = 0
-- 	maxSpeed = 8.0
-- 	acc = .3
-- 	dec = .3
-- 	turnSpeed = .08

-- 	N = 1
-- 	for i = 1, N do
-- 		table.insert(Cars, Car)
-- 	end
-- 	-- for i=1, table.getn(Cars) do
-- 	-- 	Cars[i].x = 300 + i * 50
-- 	-- 	Cars[i].y = 1700 + i * 80
-- 	-- 	Cars[i].speed = 7 * i
-- 	-- end



-- 	if love.keyboard.isDown( "left" ) then 
-- 		Left = true
-- 		Right = false
-- 	elseif love.keyboard.isDown( "right" ) then 
-- 		Right = true
-- 		Left = false
-- 	end
-- 	if love.keyboard.isDown( "down" ) then 
-- 		Up = false
-- 		Down = true
-- 	elseif love.keyboard.isDown( "up" ) then 
-- 		Up = true
-- 		Down = false
-- 	end

-- 	if (Up and speedBuff < maxSpeed) then
-- 		if speedBuff < 0  then speedBuff = speedBuff + dec
-- 		else speedBuff = speedBuff + acc end
-- 	end

-- 	if Down and speedBuff> -maxSpeed then
-- 		if speedBuff > 0  then speedBuff = speedBuff - dec
-- 		else speedBuff = speedBuff - acc end
-- 	end

-- 	if not Up and not Down then
-- 		if speedBuff - dec > 0 then speedBuff = speedBuff - dec
-- 		elseif speedBuff + dec < 0 then speedBuff = speedBuff + dec
-- 		else speedBuff = 0
-- 		end
-- 	end

-- 	if Right then angleBuff = angleBuff + turnSpeed end --* speedBuff/maxSpeed end
-- 	if Left  then angleBuff = angleBuff - turnSpeed end -- * speedBuff/maxSpeed end 

-- 	Cars[1].speed = speedBuff
-- 	Cars[1].angle = angleBuff

-- 	print (speedBuff, maxSpeed)
-- 	for i = 1, table.getn(Cars) do
-- 		move(Cars[i])
-- 	end 


-- end



















