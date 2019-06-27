blocks = {}
square = {}
amountDragging = 0
isGrabbed = nil


function makeNumbersAndBlocks( ... )
	local xVal = 20 
	num = 0
	for i= 0, 9 do
		--bounding boxes over number
	  local rect = {
	    x = xVal,
	    y = 100,
	    w = 30,
	    h = 50,
	    innerVal = num,
	    dragging = { active = false, diffX = 0, diffY = 0 }
	  }

	 table.insert(blocks,rect)
	 xVal = xVal + 100
	 num = num + 1
	end


	xVal = 225

	for i=1,3 do 
		--boxes where numbers go in
		local path = {
			x=xVal,
			y=225,
			h=80,
			w=80,
			value = 0,
			set= false
		}

		table.insert(square,path)
		xVal = xVal + 150
	end

	square[1].value = 3
	square[2].value = 2
	square[3].value = 7
end


function drawBlock()
	for i=1, table.getn(blocks) do
		 love.graphics.setColor(1, 1, 1, 0)
		
  		love.graphics.rectangle("line", blocks[i].x, blocks[i].y, blocks[i].w, blocks[i].h)
		 love.graphics.setColor(0, 1, 0, 1)
		  love.graphics.setNewFont("font.ttf", 32*1.5)
    	love.graphics.print(blocks[i].innerVal, blocks[i].x -blocks[i].w/4, blocks[i].y - blocks[i].h/4, 0, 1, 1)
		
	end
	
	--love.graphics.rectangle("line", 200, 200, 100, 100)
	for i=1, table.getn(square) do
	love.graphics.setColor(1,1,1,0)
	love.graphics.rectangle("line", square[i].x, square[i].y, square[i].w, square[i].h)
	love.graphics.setColor(1,1,1,1)
	love.graphics.line(square[i].x, square[i].y + square[i].h, square[i].x + square[i].w, square[i].y + square[i].h)
	end 
end


function pickNumber(x,y,button )
	for i=1, table.getn(blocks) do
	  if button == 1
	  and x > blocks[i].x and x < blocks[i].x + blocks[i].w
	  and y > blocks[i].y and y < blocks[i].y + blocks[i].h
	  then

	    blocks[i].dragging.active = true
	    amountDragging = 1
	    isGrabbed = blocks[i]
	    blocks[i].dragging.diffX = x - blocks[i].x
	    blocks[i].dragging.diffY = y - blocks[i].y
	    
	  end
	end
end


function dropBlock( x,y,button )
	for i=1, table.getn(blocks) do
		for j=1 , table.getn(square) do
  		if button == 1 and releaseOver(blocks[i].x,blocks[i].y, square[j], square) and blocks[i].dragging.active and amountDragging == 1 then 

  			blocks[i].x = square[j].x + square[j].w/4
  			blocks[i].y = square[j].y + square[j].h - blocks[i].h
  			amountDragging = 0
  			blocks[i].dragging.active = false 

  			if blocks[i].innerVal == square[j].value then 
  				square[j].set = true
  			end
  
		end
		end
	end
	for i=1, table.getn(blocks) do
  			blocks[i].dragging.active = false 
	end
end



function updateBlock( ... )
	for i=1, table.getn(blocks) do
	  if blocks[i].dragging.active then
	    blocks[i].x = love.mouse.getX() - blocks[i].dragging.diffX
	    blocks[i].y = love.mouse.getY() - blocks[i].dragging.diffY
	  -- elseif blocks[i].h - blocks[i].y < 450 then 
	  -- 	blocks[i].h = blocks[i].h - 10 


	  end
	end

	if square[1].set and square[2].set and square[3].set then return true  end
end








