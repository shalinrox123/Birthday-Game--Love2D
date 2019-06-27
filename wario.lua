

shirt = {
	x=100,
	y=200,
	w=50,
	h=50,
	dragging = { active = false, diffX = 0, diffY = 0 },
	value = "head"
}


clothes = {shirt}

head = {
	x=200,
	y=200,
	h=80,
	w=80,
	color= {1,0,1,1},
	value= "head",
	set= false
}

torso = {
	x=200,
	y=400,
	h=80,
	w=80,
	color= {0,1,0,1},
	value="torso",
	set= false
}


body ={head, torso}

function drawWario()
	love.graphics.setBackgroundColor(26/255,89/255,196/255,1) -- wall
	love.graphics.setColor(0,0,0,1) --black
	love.graphics.rectangle("fill", 50,50, 700, 500) -- whiteboard frame
	love.graphics.setColor(1,1,1,1) -- white
	love.graphics.rectangle("fill", 75, 75, 650, 455) -- whiteboard

	for i=1, table.getn(body) do
		love.graphics.setColor(unpack(body[i].color)) 
		love.graphics.rectangle("fill", body[i].x, body[i].y, body[i].w, body[i].h) 
	end


	for i=1, table.getn(clothes) do
		love.graphics.setColor(0,0,1,1) 
		love.graphics.rectangle("fill", clothes[i].x, clothes[i].y, clothes[i].w, clothes[i].h) 
	end

end


function pickClothes(x,y,button )
	for i=1, table.getn(clothes) do
	  if button == 1
	  and x > clothes[i].x and x < clothes[i].x + clothes[i].w
	  and y > clothes[i].y and y < clothes[i].y + clothes[i].h
	  then

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
  		if button == 1 and releaseOver(clothes[i].x,clothes[i].y, body[j], body) and clothes[i].dragging.active and amountDragging == 1 then 
  			if  clothes[i].value == body[j].value  then -- so it goes on the right body part 
  			clothes[i].x = body[j].x + body[j].w/4
  			clothes[i].y = body[j].y + body[j].h - clothes[i].h
  			amountDragging = 0
  			clothes[i].dragging.active = false 
  		end 
  			-- if clothes[i].innerVal == body[j].value then 
  			-- 	body[j].set = true
  			-- end
  
		end
		end
	end
	for i=1, table.getn(clothes) do
  			clothes[i].dragging.active = false 
	end
end



function updateClothes( ... )
	for i=1, table.getn(clothes) do
	  if clothes[i].dragging.active then
	    clothes[i].x = love.mouse.getX() - clothes[i].dragging.diffX
	    clothes[i].y = love.mouse.getY() - clothes[i].dragging.diffY
	  -- elseif clothes[i].h - clothes[i].y < 450 then 
	  -- 	clothes[i].h = clothes[i].h - 10 


	  end
	end
	--create condition statement here so when the whole body is filled 
	--the button will appear
	return false
	--if body[1].set and body[2].set and body[3].set then return true  end
end
