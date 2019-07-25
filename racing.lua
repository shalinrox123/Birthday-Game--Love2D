require "camera"
local width = love.graphics.getWidth()
local height = love.graphics.getHeight()

lap = 1
sp=5
boxImage = love.graphics.newImage('carSet/box.png')

Car = {}
Car.x = 100
Car.y = 365
Car.speed = 2
Car.angle = 0
Car.n = 0

mapData = love.image.newImageData('carSet/track.png')
mapImage = love.graphics.newImage('carSet/map2.png')
map= {
w=mapImage:getWidth( ) * 2, 
h=mapImage:getHeight( ) * 2,
X=1,
Y=1
}



carSet=love.graphics.newImage('carSet/CarSprite.png')

carImage=love.graphics.newImage('carSet/car.png')
car = {
	name= "car.png",
	x=width/2, 
	y=height/2, 
	w=carImage:getWidth( ), 
	h=carImage:getHeight( )
}


function move( arr )
	arr.x = arr.x + (math.sin(arr.angle) * arr.speed)
	arr.y = arr.y - (math.cos(arr.angle) * arr.speed)
	--print(arr.x, arr.y)
end



	speedBuff = 0
	angleBuff = 0
	maxSpeed = 10.0
	acc = .2
	dec = .3
	turnSpeed = .08
	Up = false
	Right = false
	Down = false
	Left = false




box1={boxImage,map.w/4,30, 0, 1,1}
box5={boxImage,map.w/4,650, 0, 1,1}
box9={boxImage,1205, map.h/4, 0, 1,1}

boxSet = {box1, box5, box9}

halfWay = {x=1200,
			y=map.h/4,
			w= 50, 
			h=4,
			b = false}
startPoint= {
			x= 80,
			y=map.h/4 + 13,
			w=50,
			h=4,
			b=false
}

sideStep = 0
x1 = 0
y1 = 0
x2 = 18
y2 = 25



prevTime = love.timer.getTime( )
ready = false
text = "HHello traveler.Oh gosh!The time is \nalready 4AM.Be carefule,The road \nahead is tricky.The devoloper of this\ngame got lazy and did not program this \nlevel properly.There are some obvious \nboundary issues.buT LETS CAll that a \nfeature intead :) the boxes in the \ngame do not spawn back.also the boxes \nmight help or hurt you.They can be: \n+1 lap\n-1 lap\nMap flip\nUp/Down flip\nInsta win(3%)\n\nGet 3 laps to win. \nGood luck. You'll need it."
text2 = "Tip: you can force the speed to reverse by holding space"
function frame1( ... )
	love.graphics.setNewFont("font.ttf", 20)	
	love.graphics.print(text,30, 30)
	love.graphics.print("Press start",300, 500)
	love.graphics.setNewFont("font.ttf", 10)	
	love.graphics.print(text2,100, 550)

	
	carQuad = love.graphics.newQuad(x1,y1,x2,y2, carSet:getDimensions())
	love.graphics.draw(carSet, carQuad, 600, 350, 0, 4,4)
	love.graphics.print("Select your character",520, 325)

	function love.keyreleased(key)
	   if key == "right" and x1 + x2 + 3< carSet:getWidth() then
	      	sideStep = sideStep + 1
			x1 = x1 + 20
			x2 = x2 
		end

		if key == "left" and x1 - x2 - 1 > 0 then
	      	sideStep = sideStep - 1
			x1 = x1 - 20
			x2 = x2 
		end
	end
		

	if love.keyboard.isDown("return") then ready = true end
	return false
end

function frame2( ... )
	time = love.timer.getTime( )
	camera:set()
	
	camera:setBounds(0, 0, map.w/5,map.h/8)  --camera bounds 
	love.graphics.draw(mapImage,map.w/4,map.h/4, 0, map.X,map.Y, map.w/4, map.h/4)
	love.graphics.draw(carSet, carQuad, Car.x, Car.y, Car.angle,1,1, car.w/2, car.h/2)
	--love.graphics.draw(carImage, Car.x, Car.y, Car.angle,1,1, car.w/2, car.h/2)		
	timeElapsed = time - prevTime
	canRemove = timeElapsed < 3
	for i = 1, table.getn(boxSet) do
		love.graphics.draw(unpack(boxSet[i]))
		if hitBox(boxSet[i], Car) then 
			if not canRemove then
				table.remove(boxSet, i) 
				prevTime =  time
			end
			prize()
			return
		end
	end

	love.graphics.setNewFont("font.ttf", 20)
	start= "Laps: " .. lap .. "/3"
	love.graphics.print(start, camera._x + map.w/8, camera._y)
	camera:unset()
end

WINNER = "You did it!! Yatta desu ne!\nPress the button to continue <3"

function frame3( ... )
	love.graphics.setNewFont("font.ttf", 20)	
	love.graphics.print(WINNER ,30, 30)
end


function drawRacing()

	--print(lap > 2)
	if lap > 2 then frame3() 
	elseif not ready then frame1() 
	elseif ready then frame2() end 
	
	
end

function updateRacing( )

	if ready then
		camera:setPosition(Car.x - car.x, Car.y - car.y)
		turnSpeed = .07
		withinBounds()
		carMovement()
		checkCollide()
		move(Car)
		checkLap()
	end

	if lap > 2 then return true end

end

function bounceBack( ... )
	--print(true)
	--print(mapData:getPixel( Car.x, Car.y ) )
	r,b,g,a = mapData:getPixel( Car.x, Car.y ) 
	
		if (r~= 0 and b~=0 and g~=0 and a == 1 )then
			--print("t")
			return true
		else
			--print("f")
			return false
		end
end


function withinBounds( ... )
	if Car.x > 1250 then Car.x =  1250
	elseif Car.x <0 then Car.x = 0 end

	if Car.y > 700 then Car.y = 700
	elseif Car.y <0 then Car.y = 0 end

	--print(Car.x, map.w)

end

function checkCollide( ... )
	if not bounceBack() then 
		sp = -sp
		if Car.speed > 0  or Up then
			for i=1,10 do
				Car.x =  Car.x + .1
				Car.y = Car.y + .1
			end
		elseif Car.speed < 0 or Down then
			for i=1,10 do
				if Car.x + 0.1 < 1250 and Car.y + 0.1 < 700 then
					Car.x =  Car.x + .1
					Car.y = Car.y + .1
				end
			end
		end
	end
end

function carMovement( ... )
	
	if love.keyboard.isDown( "left" ) then 
		Left = true
		Right = false
	elseif love.keyboard.isDown( "right" ) then 
		Right = true
		Left = false
	else
		Right = false
		Left = false
	end
	if love.keyboard.isDown( "down" ) then 
		Up = false
		Down = true
	elseif love.keyboard.isDown( "up" ) then 
		Up = true
		Down = false
	else
		Up = false
		Down = false
	end

	if love.keyboard.isDown( "space" ) then sp = - sp end

	 if Car.y*2 > map.h * 3 then 
    	Car.y = map.h * 3 - Car.y
    end 
    if Car.x*2 > map.w * 3 then 
    	Car.x = map.w * 3 - Car.x
    end

    if (Up and speedBuff < maxSpeed) or not bounceBack()  then
		speedBuff = sp
		-- if speedBuff < 0  then speedBuff = speedBuff -- + .005
		-- else speedBuff = 3 end
	end

	

	if Down and speedBuff> -maxSpeed or not bounceBack() then
		speedBuff = -sp
	end
	if not Up and not Down then speedBuff = 0 end

	if Right then angleBuff = angleBuff + turnSpeed end 
	if Left  then angleBuff = angleBuff - turnSpeed end 

	Car.speed = speedBuff
	Car.angle = angleBuff

end

function getTime( ... )
	prevTime = love.timer.getTime()
	return love.timer.getTime()
end

function hitBox(a,b)
	   if ((b.x >= a[2] + boxImage:getWidth()) or
		   (b.x + carImage:getWidth()/2 <= a[2]) or
		   (b.y >= a[3] + boxImage:getHeight()) or
		   (b.y + carImage:getHeight()/2 <= a[3])) then
			  return false 
	   else return true
           end
	end

function prize( ... )
	p = math.random(5)

	if p == 1 then sp = -sp 
	elseif p == 2 then lap = lap - 1
	elseif p == 3 then lap = lap + 1
	elseif p == 4 then 
		p = math.random(6)
		if p == 4 then lap = 3 end 
	elseif p == 5 then 
		map.Y = -map.Y
	end
end	

function win( ... )
	return true
end

function checkLap( ... )

	function collide(a,b)
	   if ((b.x >= a.x + carImage:getWidth()/2) or
		   (b.x + b.w <= a.x) or
		   (b.y >= a.y + carImage:getHeight()/2) or
		   (b.y + b.h <= a.y)) then
			  return false 
	   else return true end
	end

	if collide(Car, startPoint) and Up then startPoint.b = true end
	if collide(Car, halfWay) and Up then halfWay.b = true end

	if startPoint.b and halfWay.b then 
		lap = lap + 1
		startPoint.b = false
		halfWay.b = false 
	end

	if lap > 2 then win() end
end











