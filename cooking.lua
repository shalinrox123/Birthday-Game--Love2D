rect = {
    x = 300,
    y = 300,
    w = 200,
    h = 100,
    dragging = { active = false, diffX = 0, diffY = 0 }
  }
egg={
		x=200,
		y=100,
		r=30
	}
holdEgg = false
canCut = false
canCoat = false
ingredientsCounter = 0
ingredients={}
wasDown = false --indicates mouse state on previous frame

i={
	x=500,
	baseX = 500,
	y= 300,
	baseY = 300,
	w=10,
	h=10,
	touch = 0
}


function drawMama( ... )
	love.graphics.setColor(.7,.5,.8,1)
	love.graphics.rectangle("fill", rect.x, rect.y, rect.w, rect.h)
	love.graphics.setColor(.1,1,.8,1)
	-- if not canCut then 
	-- 	for i=1,#ingredients do
	-- 		love.graphics.rectangle("fill", ingredients[i].x, ingredients[i].y, ingredients[i].w, ingredients[i].h)
	-- 	end
	-- end
	love.graphics.rectangle("fill", i.x, i.y, i.w, i.h)

	--coatChicken()
end

function updateMama( ... )
-- 	if canCoat then
-- 	rect.x = love.mouse.getX() - rect.dragging.diffX
-- 	rect.y = love.mouse.getY() - rect.dragging.diffY
-- end
	mixIngeredients()

	if canCut then cutChicken()
	elseif canCut then
		createIngredients()
		for i=1, #ingredients do
			if ingredients[i].dragging.active  then
				ingredients[i].x = love.mouse.getX() - ingredients[i].dragging.diffX
				ingredients[i].y = love.mouse.getY() - ingredients[i].dragging.diffY
			end
	end
 end

  
end


function mixIngeredients( ... )
	print(i.touch)
	if love.mouse.isDown(1) then
		x,y = love.mouse.getPosition()
		if ((i.x - i.w >= x) or
		   (i.x + i.w  <= x) or
		   (i.y - i.h >= y) or
		   (i.y + i.h <= y)) then
	 	else 
	 		print(true)
	 		i.y=i.y+20
	 		i.touch = i.touch+1
		 end
		end
	if i.touch < 4 and not love.mouse.isDown(1)then
		--figure out how to move x and y in certian directions to get stiring 
		i.x = i.baseX
		i.y = i.baseY
		i.touch = 0
	end

	
end

function createIngredients()
  X =50
	for i=1,3 do
		rectangle={
			x=X,
			baseX=X,
			y= 100,
			baseY = 100,
			w = 30,
			h=30,
			placed = false,
			dragging = { active = false, diffX = 0, diffY = 0 }
		}
		X = X + 40
		if #ingredients < 3 then
			table.insert(ingredients,rectangle)
		end
	end


end

-- butter the pan?
function cookFood( ... )
	--place stuff on skillet
	--turn on heat
	--turn off heat when cooked
	--flip chicken
	--repeat
end

function coatChicken( ... )
	--drag and drop chicken into  flour egg bread lay on pan
	--pick up chiekn, must hit all 3 bowls, place on baking pan
	love.graphics.rectangle("fill", rect.x, rect.y, rect.w, rect.h)

end

function crackEgg( ... )
	x,y = love.mouse.getPosition()
	if holdEgg then
		egg.x = x
		egg.y = y
	end

	love.graphics.circle("fill", egg.x, egg.y, egg.r)
	love.graphics.rectangle("fill", 100, 100, 20, 200)

	if ((egg.x - egg.r/2 >= 100 + 20) or --to get a little more tht the edge of the egg
		   (egg.x + egg.r  <= 100) or
		   (egg.y - egg.r>= 100 + 200) or
		   (egg.y + egg.r <= 100)) then
	 else 
	 	print(egg.r)
	 	egg.r = 0 -- remove egg
	 end
end

function cutChicken( ... )

  if rect.dragging.active then
	rect.x = love.mouse.getX() - rect.dragging.diffX
	rect.y = love.mouse.getY() - rect.dragging.diffY
  end

  if love.mouse.isDown(1) and not wasDown and rect.w > 0 then 
    rect.w = rect.w - 20
  end
  wasDown = love.mouse.isDown(1)
end

function press(x, y, button)
	for i=1, #ingredients do
	  if button == 1
	  and x > ingredients[i].x  and x < ingredients[i].x + ingredients[i].w
	  and y > ingredients[i].y  and y < ingredients[i].y + ingredients[i].h
	  then
	    ingredients[i].dragging.active = true
	    ingredients[i].dragging.diffX = x - ingredients[i].x
	    ingredients[i].dragging.diffY = y - ingredients[i].y
	    
	  end
	end
	

	if ((egg.x - egg.r >= x) or
		   (egg.x + egg.r  <= x) or
		   (egg.y - egg.r>= y) or
		   (egg.y + egg.r <= y)) then
	 else 
	 	holdEgg = true
	 end

	 if button == 1
	  and x > rect.x  and x < rect.x + rect.w
	  and y > rect.y  and y < rect.y + rect.h
	  then
	    rect.dragging.active = true
	    rect.dragging.diffX = x - rect.x
	    rect.dragging.diffY = y - rect.y
	    
	  end

	  if ((rect.x - rect.w >= x) or
		   (rect.x + rect.w  <= x) or
		   (rect.y - rect.h>= y) or
		   (rect.y + rect.h <= y)) then
	 else 
	 	canCoat = true
	 end


end
  

function releasedOver(a, b)
	if ((b.x >= a.x + a.w) or
		   (b.x + b.w <= a.x) or
		   (b.y >= a.y + a.h) or
		   (b.y + b.h <= a.y)) then
			  return false 
	 else 
	 	return true
	 end
end


function release(x, y, button)
  if button == 1 then rect.dragging.active = false end
  for i=1, #ingredients do
  	if button == 1 then 
  		if releasedOver(ingredients[i], rect) then 
  			ingredientsCounter= ingredientsCounter + 1
  			ingredients[i].w = 0
  			ingredients[i].h = 0
  		end
  		ingredients[i].dragging.active = false
  		ingredients[i].x = ingredients[i].baseX
  		ingredients[i].y = ingredients[i].baseY
  	end
  end
  if ingredientsCounter == #ingredients then canCut = true end
end
