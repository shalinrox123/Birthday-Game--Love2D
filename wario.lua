
--this is all grossly hardcoded im sorry :3

shirt = {
	image="shirt",
	x=5,
	y=20,
	w=50,
	h=50,
	dragging = { active = false, diffX = 0, diffY = 0 },
	value = "torso",
	set = false
}

newShirt = {
	image="new shirt",
	x=570,
	y=20,
	w=50,
	h=50,
	dragging = { active = false, diffX = 0, diffY = 0 },
	value = "torso",
	set = false
}


gloves = {
	image="gloves",
	x=5,
	y=350,
	w=50,
	h=50,
	dragging = { active = false, diffX = 0, diffY = 0 },
	value = "hands",
	set = false
}


newGloves = {
	image="new gloves",
	x=500,
	y=350,
	w=50,
	h=50,
	dragging = { active = false, diffX = 0, diffY = 0 },
	value = "hands",
	set = false
}

hat = {
	image="hat",
	x=5,
	y=300,
	w=50,
	h=50,
	dragging = { active = false, diffX = 0, diffY = 0 },
	value = "head",
	set = false
}

newHat = {
	image="new hat",
	x=570,
	y=300,
	w=50,
	h=50,
	dragging = { active = false, diffX = 0, diffY = 0 },
	value = "head",
	set = false
}


pants = {
	image="pants",
	x=5,
	y=130,
	w=50,
	h=50,
	dragging = { active = false, diffX = 0, diffY = 0 },
	value = "legs",
	set = false
}

newPants = {
	image="new pants",
	x=570,
	y=130,
	w=50,
	h=50,
	dragging = { active = false, diffX = 0, diffY = 0 },
	value = "legs",
	set = false
}

shoes = {
	image="shoes",
	x=5,
	y=430,
	w=50,
	h=50,
	dragging = { active = false, diffX = 0, diffY = 0 },
	value = "feet",
	set = false
}

newShoes = {
	image="new shoes",
	x=570,
	y=430,
	w=50,
	h=50,
	dragging = { active = false, diffX = 0, diffY = 0 },
	value = "feet",
	set = false
}

clothes = {newShirt, shirt, gloves, newGloves, hat, newHat, pants, newPants, shoes, newShoes}

head = {
	x=350,
	y=200,
	h=80,
	w=80,
	color= {1,0,1,1},
	value= "head",
	set= false
}

torso = {
	x=350,
	y=270,
	h=100,
	w=150,
	color= {0,1,0,1},
	value="torso",
	set= false
}

hands = {
	x=240,
	y=210,
	h=80,
	w=350,
	color= {0,1,0,1},
	value="hands",
	set= false
}

legs = {
	x=320,
	y=330,
	h=110,
	w=170,
	col1or= {0,1,0,1},
	value="legs",
	set= false
}

feet = {
	x=290,
	y=400,
	h=80,
	w=240,
	col1or= {0,1,0,1},
	value="feet",
	set= false
}


body = {feet, hands, head, legs, torso}

local text = "*NSFW warning*\n\nyour naked girlfriend is delirious \nand needs help getting dressed. \n\nmake sure she is completly covered."
local ready = false
local function frame1( ... )
	love.graphics.setNewFont("font.ttf", 20)	
	love.graphics.print(text,30, 30)
	love.graphics.print("Press start",300, 500)
	if love.keyboard.isDown("return") then 
		ready=true 
		prevTime = love.timer.getTime()
	end
end

local function frame2( ... )
	love.graphics.setBackgroundColor(26/255,89/255,196/255,1) -- wall
	love.graphics.setColor(0,0,0,1) --black
	love.graphics.rectangle("fill", 50,50, 700, 500) -- whiteboard frame
	love.graphics.setColor(1,1,1,1) -- white
	love.graphics.rectangle("fill", 75, 75, 650, 455) -- whiteboard

	skin = love.graphics.newImage("wario set/body.png")
	love.graphics.draw(skin, 230, 150,0,1.5, 1.5)

	for i=1, table.getn(clothes) do
			shirt = love.graphics.newImage("wario set/"..clothes[i].image..".png")
			clothes[i].w, clothes[i].h = shirt:getDimensions( )
			love.graphics.draw(shirt, clothes[i].x, clothes[i].y, 0, 1.5, 1.5)
			--print(clothes[i].x, clothes[i].y)
	end
end


function drawWario()
	collectgarbage()
	if not ready then frame1() end 
	if ready then frame2() end

end


function updateClothes( ... )
	if ready then
	for i=1, table.getn(clothes) do
	  if clothes[i].dragging.active then
	    clothes[i].x = love.mouse.getX() - clothes[i].dragging.diffX
	    clothes[i].y = love.mouse.getY() - clothes[i].dragging.diffY
	  end
	end
	--create condition statement here so when the whole body is filled 
	--the button will appear
	if (clothes[1].set or clothes[2].set) and (clothes[3].set or clothes[4].set) and (clothes[5].set or clothes[6].set) and (clothes[7].set or clothes[8].set) and (clothes[9].set or clothes[10].set) then 
		return true
	end
  end
end

function pickClothes(x,y,button )
	for i=1, table.getn(clothes) do
	  if button == 1
	  and x > clothes[i].x and x < clothes[i].x + clothes[i].w
	  and y > clothes[i].y and y < clothes[i].y + clothes[i].h
	  then
	  	clothes[i].set = false
	    clothes[i].dragging.active = true
	    amountDragging = 1
	    isGrabbed = clothes[i]
	    clothes[i].dragging.diffX = x - clothes[i].x
	    clothes[i].dragging.diffY = y - clothes[i].y
	    
	  end
	end
end


function dropClothes( x,y,button )
	for i=1, table.getn(clothes) do
		for j=1 , table.getn(body) do
			

		
  		if button == 1 and releaseOver(clothes[i].x + 50,clothes[i].y +50, body[j], body) and clothes[i].dragging.active and amountDragging == 1 then 
  			if  clothes[i].value == body[j].value  then -- so it goes on the right body part 
  			
  				if clothes[i].image == "shirt" then
		  			clothes[i].x = body[j].x -52
		  			clothes[i].y = body[j].y - 20
		  		elseif clothes[i].image == "new shirt" then
		  			clothes[i].x = body[j].x -59
		  			clothes[i].y = body[j].y -20
		  		elseif clothes[i].image == "gloves" then
		  			clothes[i].x = body[j].x - 9
		  			clothes[i].y = body[j].y -38
		  		elseif clothes[i].image == "new gloves" then
		  			clothes[i].x = body[j].x - 9
		  			clothes[i].y = body[j].y -38
		  		elseif clothes[i].image == "hat" then
		  			clothes[i].x = body[j].x - 55
		  			clothes[i].y = body[j].y -38
		  		elseif clothes[i].image == "new hat" then
		  			clothes[i].x = body[j].x - 50
		  			clothes[i].y = body[j].y - 30
		  		elseif clothes[i].image == "pants" then
		  			clothes[i].x = body[j].x - 5
		  			clothes[i].y = body[j].y - 35
		  		elseif clothes[i].image == "new pants" then
		  			clothes[i].x = body[j].x - 8.5
		  			clothes[i].y = body[j].y + 23
		  		elseif clothes[i].image == "shoes" then
		  			clothes[i].x = body[j].x - 25
		  			clothes[i].y = body[j].y - 43
		  		elseif clothes[i].image == "new shoes" then
		  			clothes[i].x = body[j].x - 24
		  			clothes[i].y = body[j].y - 47
		  		end
		  		body[j].set = true
		  		clothes[i].set = true
		  		
  			--amountDragging = 0
  			clothes[i].dragging.active = false 
  		end 
  			if clothes[i].innerVal == body[j].value then 
  				body[j].set = true
  			end
  			

		end
		end
		--print(clothes[i].value, clothes[i].set)
	end


	for i=1, table.getn(clothes) do
  			clothes[i].dragging.active = false 
	end
end



