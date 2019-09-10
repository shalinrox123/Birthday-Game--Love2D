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
	baseX = 480,
	y= 300,
	baseY = 300,
	w=20,
	h=10,
	touch = 0,
	cut = 0
}

sugaSpreadSheet = love.graphics.newImage("Cooking/Suga.png")
SugaSprite = {}
SugaQuad = nil
addX = 34*2
addY = 34*2
maxMove = 3
maxMoveY = 0
moveOver = 0
step = 0

r = 0

function nextStep( ... )
	love.timer.sleep(2.5)
	step = step + 1
end

function part1( ... )
	cutSuga()
   	lineFlash()
   	if followLine() then nextStep() end
end

function part2( ... )
	if crackEgg() then nextStep() end
end

function part3( ... )
	local w =0
	local h = 0
	w, h = love.window.getMode()
	love.graphics.print("ingredient: ", w/2-220, 10)
	love.graphics.setNewFont("font.ttf", 20)
	list = {"sugar", "flour", "baking soda", "vanilla extract", "milk", "oil"}
	for i=1,#ingredients do
			love.graphics.rectangle("fill", ingredients[i].x, ingredients[i].y, ingredients[i].w, ingredients[i].h)
			x,y = love.mouse.getPosition()
			if x > ingredients[i].x  and x < ingredients[i].x + ingredients[i].w
		  and y > ingredients[i].y  and y < ingredients[i].y + ingredients[i].h then
		  	love.graphics.print(list[i], w/2, 10)
	  end
		end
		
	createIngredients(#list)
	print(#ingredients)
	if ingredientsCounter == #ingredients then nextStep() end

	--also make it so that only what is needed should be picked up?
end


function part4( ... )
		love.graphics.setColor(.7,.5,.8,1)
	love.graphics.rectangle("fill", rect.x, rect.y, rect.w, rect.h)
	love.graphics.setColor(.1,1,.8,1)

	--SPIN???
	--use r in graphics to rotate
	--add mouse drag/button click
	--also have 4 points the image must corss in succession for one full roation
	x,y = love.mouse.getPosition()
	
	w,h = sugaSpreadSheet:getDimensions()
	img = {
		x=200, y =200, w = w, h=h
	}
	love.graphics.draw(sugaSpreadSheet, img.x, img.y, r, 1,1, w/2,h/2)
	if true
	and x > img.x - img.w  and x < img.x + img.w*2
	and y > img.y - img.h and y < img.y + img.h*2 then
		r = math.atan2(y-img.x, x-img.y)
	end
	print(r)
	
end

function drawMama( ... )

	-- if not canCut then
	--
	-- end

	if step == 1 then part1()
	elseif step == 2 then part2()
	elseif step == 3 then part3()
	elseif step == 4 then part4()
	end

	--coatChicken()
end

function updateMama( ... )
-- 	if canCoat then
-- 	rect.x = love.mouse.getX() - rect.dragging.diffX
-- 	rect.y = love.mouse.getY() - rect.dragging.diffY
-- end
if step == 0 then step = 1 end

	if #SugaSprite == 0  then getSugaQuads() end

		createIngredients()
		for i=1, #ingredients do
			if ingredients[i].dragging.active  then
				ingredients[i].x = love.mouse.getX() - ingredients[i].dragging.diffX
				ingredients[i].y = love.mouse.getY() - ingredients[i].dragging.diffY
			end
	
		 end


end








function getSugaQuads()
	w,h= sugaSpreadSheet:getDimensions()
	w = h/3
sprite = {w = w, h = w}
initial = 0
final = 0
findStart = sprite.w
findEnd = sprite.h
	sugaSpreadSheet = love.graphics.newImage("Cooking/Suga.png")
	for i = 1,3 do
		for j = 1,4 do
			table.insert(SugaSprite,love.graphics.newQuad(initial,final,findStart,findEnd, sugaSpreadSheet:getDimensions()))
			initial = initial + sprite.w
		end
			initial = 0
			final = final + sprite.h
	end

	table.remove(SugaSprite, 8)
	table.remove(SugaSprite, 4)
	table.remove(SugaSprite, #SugaSprite)
	SugaQuad = SugaSprite[1]

end

function cutSuga( ... )
		love.graphics.setColor(1,1,1,1)
	--love.graphics.draw(sugaSpreadSheet, 300,100,0,1,1)
	local x =350
	local y=300
	moveX = 0
	column = 0
	row = 0
	for i=1,#SugaSprite do
		love.graphics.draw(sugaSpreadSheet,SugaSprite[i], x,y,0,1,1)
		x = x + addX

		if maxMove - (i+ column) <= 0 then x = x + 2 end
		moveX = moveX + 1
		if moveX > 2 then --shift y value over
			row = row - 3
			x = 350
			--make it so only one column moves at a time
			y = y + addY
			if maxMoveY - (i + row) <= 1 and i%maxMoveY ==0  then y = y + 2 end

			moveX = 0
			column = column - 3


		end

	end
end

function lineFlash( ... )
	local a = math.abs(math.cos(love.timer.getTime() * 1 * math.pi))
	love.graphics.setColor(1, 0, 0, a)
	if i.cut < 2 then
		--love.graphics.circle("line", i.x, i.y, i.w/2)
		love.graphics.line(i.baseX, i.baseY-5, i.baseX , i.baseY*1.75)
	elseif i.cut < 4 then
		--love.graphics.circle("line", i.x, i.y, i.w/2)
		love.graphics.line(i.baseX, i.baseY, i.baseX*1.75 , i.baseY)
	end
end



local change = 2
function followLine( ... )
	--
	if love.mouse.isDown(1) then

		x,y = love.mouse.getPosition()
		if ((i.x - i.w >= x) or
		   (i.x + i.w  <= x) or
		   (i.y - i.h >= y) or
		   (i.y + i.h <= y)) then
	 	else
	 		--print(true)
	 		if i.cut <2 then
		 		i.y=i.y+20
		 		i.touch = i.touch+1
	 		else
		 		i.x=i.x+20
		 		i.touch = i.touch+1
		 	end
		 end
		end
	if i.touch < 11 and not love.mouse.isDown(1)then

		i.x = i.baseX
		i.y = i.baseY
		i.touch = 0

	end
	if i.touch >= 11 and not love.mouse.isDown(1)then

		if i.cut < 1 then
			i.baseX = i.baseX - 34*2
		elseif i.cut ==1 then
			i.baseX = i.baseX - 34*2
			i.baseY = i.baseY + 34*4
		else
			i.baseY = i.baseY - 34*2
		end

		i.x = i.baseX
		i.y = i.baseY
		i.touch = 0
		i.cut = i.cut +1
		moveOver = 2
		maxMove = maxMove - 1

		if maxMove <= 0 and maxMoveY - change >= -3 then
			maxMoveY = maxMoveY - change
			change = 1
		end
		--row = row - 3
	end
	print(i.cut)
	return i.cut >=4
end











function createIngredients(size)
  X =50
  if size == nil then size = 0 end
	for i=1,size do
		rectangle={
			x=X,
			baseX=X,
			y= 100,
			baseY = 100,
			w = 45,
			h=60,
			placed = false,
			dragging = { active = false, diffX = 0, diffY = 0 }
		}
		X = X + rectangle.w + 5
		if #ingredients < size then
			table.insert(ingredients,rectangle)
		end
	end


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
	 	--print(egg.r)
	 	egg.r = 0 -- remove egg
	 	return true
	 end
end

-- function cutChicken( ... )

--   if rect.dragging.active then
-- 	rect.x = love.mouse.getX() - rect.dragging.diffX
-- 	rect.y = love.mouse.getY() - rect.dragging.diffY
--   end

--   if love.mouse.isDown(1) and not wasDown and rect.w > 0 then
--     rect.w = rect.w - 20
--   end
--   wasDown = love.mouse.isDown(1)
-- end


function press(x, y, button)

if step == 3 then
	for i=1, #ingredients do
	  if button == 1
	  and x > ingredients[i].x  and x < ingredients[i].x + ingredients[i].w
	  and y > ingredients[i].y  and y < ingredients[i].y + ingredients[i].h
	  then
	  	print("true")
	    ingredients[i].dragging.active = true
	    ingredients[i].dragging.diffX = x - ingredients[i].x
	    ingredients[i].dragging.diffY = y - ingredients[i].y

	  end
	end
end

if step == 2 then
	if ((egg.x - egg.r >= x) or
		   (egg.x + egg.r  <= x) or
		   (egg.y - egg.r>= y) or
		   (egg.y + egg.r <= y)) then
	 else
	 	holdEgg = true
	 end
	end

	 -- if button == 1
	 --  and x > rect.x  and x < rect.x + rect.w
	 --  and y > rect.y  and y < rect.y + rect.h
	 --  then
	 --    rect.dragging.active = true
	 --    rect.dragging.diffX = x - rect.x
	 --    rect.dragging.diffY = y - rect.y

	 --  end

	 --  if ((rect.x - rect.w >= x) or
		--    (rect.x + rect.w  <= x) or
		--    (rect.y - rect.h>= y) or
		--    (rect.y + rect.h <= y)) then
	 -- else
	 -- 	canCoat = true
	 -- end


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
  
end
