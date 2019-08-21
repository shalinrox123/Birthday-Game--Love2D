
left = false
wasLeft = false
right = false
wasRight = false
jump = false
canJump = false
jumpCounter = 0
velCounter = 1


function isCollidingTop(platform, player)
	if (player.x >= platform.x + platform.w - 30) or
		(player.x + player.w <= platform.x) or
		(player.y + player.h/2  >= platform.y) or
		(player.y +player.h <= platform.y) then
		return false 
	else 
		return true
	end
end

function isCollidingBottom(platform, player)
	if (player.x >= platform.x + platform.w - 30) or
		(player.x + player.w/2 <= platform.x) or
		(player.y < platform.y - platform.h + 3) or
		(player.y  >= platform.y + platform.h) then
		return false 
	else 
		return true
	end
end


function isColliding(a,b)
	if ((b.x >= a.x + a.w - 30) or
		(b.x + b.w <= a.x) or
		(b.y >= a.y + a.h) or
		(b.y + b.h <= a.y)) then
		return false 
	else 
		return true
	end
end

function makeJump(player)
	if jump then
		jump = false
    	vel = jumpVel
    	while vel <= 0 do
			player.y = player.y + grav
	    	grav = grav + vel
	    	vel = vel + velCounter
    	end
    end
end

function playerMove(player)


	if love.keyboard.isDown("left") then
        player.x = player.x - 10
        left = true
        right = false
        wasRight = false
        wasLeft = true
    end
    if love.keyboard.isDown("right") then
        player.x = player.x + 10
        left = false
        right = true
        wasRight = true
        wasLeft = false
    end

    --released
    function love.keyreleased(key)

       if key == "left" then
          left = false
       end

        if key == "right" then
          right = false
       end
    end

    --jump
    function love.keypressed(key)
       if (key == "space" or key == "up") and jumpCounter < 2 then
       	jump = true
       	grav = 0
       	jumpCounter = jumpCounter + 1
       	makeJump(player)
       end
    end

  sky = love.graphics.newImage("img/sky.png")
  width = sky:getWidth()*2
   	--boundaries
    if player.x  + player.w > (width) then 
    	player.x = (width) - player.w
    end

    if player.x < (0) then 
    	player.x = 0
    end

    if player.y < 0 then 
    	player.y = 0
    end
end


function checkGround(player)
	if player.y  + player.h < (ground) and not jump then
    	player.y = player.y + grav
    	grav = grav + vel
    elseif player.y + player.h > ground then
    	player.y = ground - player.h
    	grav = 0
    	jumpCounter = 0

    else
    	grav = 0
    	vel = initialVel
    end
end
