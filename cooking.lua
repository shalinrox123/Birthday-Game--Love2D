rect = {
    x = 300,
    y = 300,
    w = 200,
    h = 100,
    dragging = { active = false, diffX = 0, diffY = 0 }
  }
-- egg={
-- 		x=200,
-- 		y=100,
-- 		r=30
-- 	}

eggs={}
holdEgg = false
canCut = false
canCoat = false
ingredientsCounter = 0
ingredients={}
wasDown = false --indicates mouse state on previous frame


local i={	x=500,
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
playD = 0
function playDing( ... )
	if playD == 0 then
		doneDing = love.audio.newSource("sound/ding.wav", "queue")
		doneDing:isLooping(false)
		doneDing:play()
		playD = 1
	end
end

function nextStep( ... )
	--love.timer.sleep(2.5)
	step = step + 1
end

function part1( ... )
	cutting = love.graphics.newImage("Cooking/cutting board.png")
	love.graphics.draw(cutting,0,0)

	love.graphics.setColor(0,0,0,1)
	text = "Cut along the red lines"
	love.graphics.print(text,30, 530)
	love.graphics.setColor(1,1,1,1)

	
	cutSuga()
   	lineFlash()
   	love.graphics.setColor(1,1,1,1)
   	if followLine() then nextStep() end
end

function part2( ... )
	love.graphics.draw(tablei,0,0)
	love.graphics.setColor(0,0,0,1)
	text = "Click on the egg and crack it on the \nbowl"
	love.graphics.print(text,30, 530)
	love.graphics.setColor(1,1,1,1)
	if #eggs == 0  then makeEggs() end
	if crackEgg() then nextStep() end
end

function makeEggs( ... )
	-- body
	for i=1,7 do 
		local egg ={
			x= love.math.random(300, 750),
			y=love.math.random(50, 305),
			r=30,
			hold = false
		}
		table.insert(eggs,egg)
	end
end

function part3( ... )
	love.graphics.draw(tablei,0,0)
	love.graphics.setColor(0,0,0,1)
	text = "Drag ingredients into the mixing bowl"
	love.graphics.print(text,30, 530)
	love.graphics.setColor(1,1,1,1)
	local w =0
	local h = 0
	w, h = love.window.getMode()
	love.graphics.print("ingredient: ", w/2-220, 10)
	love.graphics.setNewFont("font.ttf", 20)
	list = {"sugar", "flour", "baking soda", "vanilla extract", "milk", "oil"}
	for i=1,#ingredients do
			
			--love.graphics.rectangle("line", ingredients[i].x, ingredients[i].y, ingredients[i].w, ingredients[i].h)
			if ingredients[i].w > 0 then listVal = "Cooking/"..list[i]..".png"
			else listVal = "Cooking/emptybowl.png" end
			ing = love.graphics.newImage(listVal)
			love.graphics.draw(ing, ingredients[i].x, ingredients[i].y)
			x,y = love.mouse.getPosition()
		if x > ingredients[i].x  and x < ingredients[i].x + ingredients[i].w
		  and y > ingredients[i].y  and y < ingredients[i].y + ingredients[i].h then
		  	love.graphics.print(list[i], w/2, 10)
	  end
		end
		
	createIngredients(#list)
	print(#ingredients)
	if ingredientsCounter == #ingredients then nextStep() end

	
	love.graphics.draw(love.graphics.newImage("Cooking/mix.png"), rect.x, rect.y)
	--love.graphics.rectangle("line", rect.x, rect.y, rect.w, rect.h)
	--also make it so that only what is needed should be picked up?
end

mixValue = 1
local boxes = {}
tablei = love.graphics.newImage("Cooking/table.png")
touchCounter = 0
function part4( ... )

	love.graphics.draw(tablei,0,0)

	love.graphics.setColor(0,0,0,1)
	text = "Mix."
	love.graphics.print(text,30, 530)
	love.graphics.setColor(1,1,1,1)

	mixBowl = "Cooking/bowl"..mixValue..".png"
	mix = love.graphics.newImage(mixBowl)
	w,h = mix:getDimensions()

	love.graphics.draw(mix, 400, 300,r, 2,2,w/2,h/2)
	local img = {
		x=400, y =300, w = w*2, h=h*2
	}

	if #boxes == 0 and img ~= nill then	createBoxes(img) end
	checkTouch(boxes)

	-- love.graphics.setColor(.7,.5,.8,1)
	-- --love.graphics.rectangle("fill", rect.x, rect.y, rect.w, rect.h)
	-- love.graphics.setColor(.1,1,.8,1)

	--SPIN???
	--use r in graphics to rotate
	--add mouse drag/button click
	--also have 4 points the image must corss in succession for one full roation
	x,y = love.mouse.getPosition()
	
	--w,h = sugaSpreadSheet:getDimensions()
	
	--love.graphics.draw(sugaSpreadSheet, img.x, img.y, r, 1,1, w/2,h/2)
	if true
	and x > img.x - img.w/2  and x < img.x + img.w/2
	and y > img.y - img.h/2 and y < img.y + img.h/2 then
		r = math.atan2(y-img.x, x-img.y)
	end
	--print(r)

	-- for i=1,#boxes do
	-- 	--love.graphics.rectangle("line", boxes[i].x, boxes[i].y, boxes[i].w, boxes[i].h)
	-- end
	
	if touchCounter == 16 then
		boxes={}
	elseif touchCounter >= 32 and mixValue < 5 then
		boxes={}
		touchCounter = 0
		mixValue = mixValue+1
	end


	if mixValue >= 5 then nextStep() end 
end

function createBoxes(img)
	pi = 0
	for i = 1, 16 do
		print(#boxes)
		pi = math.pi/8 + pi
		rect = {
			x = math.cos(pi)*img.w*.4 + img.x - 75,
			y = math.sin(pi)*img.h*.4 + img.y - 75,
			w = 150,
			h = 150
		}
		table.insert(boxes,rect)
	end
end

touchCounter = 0
function checkTouch(a)
	x,y = love.mouse.getPosition()
	for i = 1, #a do
		if isHover(a[i], x,y)then 
			--print(true, a[i].x, a[i].y)
			a[i].w=0
			a[i].h=0
			touchCounter = touchCounter+1
			print(touchCounter)
		end
	end
end


function isHover(a,mx, my)
	   if ((mx >= a.x + a.w) or
		   (mx <= a.x) or
		   (my >= a.y + a.h) or
		   (my <= a.y)) then
			  return false 
	   else return true
           end
	end








local num = ''
numpad={}
function part5( ... )	
	love.graphics.setColor(1,1,1,1)
	oven = love.graphics.newImage("Cooking/oven.png")
	love.graphics.draw(oven,0,0)
	text = "Enter in the correct temperature"
	love.graphics.print(text,30, 10)
	if #numpad==0 then createNumPad() end
	checkNumpad(numpad)
	if not love.mouse.isDown(1) then down = true end


	for i=1,#numpad do
		love.graphics.setColor(numpad[i].color)
		love.graphics.rectangle("fill", numpad[i].x, numpad[i].y, numpad[i].w, numpad[i].h)
			x = 1
			if i < 10 then x =i
			elseif i == 11 then x = 0
			elseif i == 10 then x = "<-"
			elseif i == 12 then x="E"
			end
			love.graphics.setColor(0,0,0)
			love.graphics.setNewFont("font.ttf", 10)	
			love.graphics.print(x, numpad[i].x + numpad[i].w/4, numpad[i].y+numpad[i].h/10)
	end	

	love.graphics.setNewFont("font.ttf", 15)
	love.graphics.setColor(1,1,1,1)
	love.graphics.print(num, 350, 80)

end

function createNumPad()

	y = 73
	for i = 1, 4 do
		x=590
		for j=1,3 do
			
			local rect = {
				x = x,
				y = y,
				w = 21,
				h = 15
			}
			x=x+22
			table.insert(numpad,rect)
		end
		y=y+16
	end
end

function checkNumpad(a)
	x,y = love.mouse.getPosition()
	for i = 1, #a do
		if isHover(a[i], x,y) and love.mouse.isDown(1) and down then
			a[i].color={1,0,0,1} 
			if num == 0 and i < 10 then num = i 
			elseif i < 10 then num = num..i
			elseif i == 11 then num = num .. 0 
			elseif i == 10 and #num > 0 then num = num:sub(1, -2) 
			elseif i == 12 then checkVal(num)
			end
			--print(num,i)
			down = false
		elseif isHover(a[i], x,y)then 
			a[i].color={1,1,1,.5}
		else
			a[i].color={1,1,1,1}
		end
	end
end

function checkVal(a )
	if a ~= "1017" then num = ''
	else nextStep() end
end


linePi = -math.pi/2
piCounter = 0
function part6( ... )
	love.graphics.setColor(1,1,1,1)
	love.graphics.draw(tablei,0,0)
	love.graphics.setColor(0,0,0,1)
	text = "Wait...\nBaking"
	love.graphics.print(text,30, 530)
	love.graphics.setColor(1,1,1,1)
	love.graphics.setColor(1,.5,7,1)
	love.graphics.circle("fill", 400, 300, 300)
	love.graphics.setColor(1,1,1,1)
	love.graphics.circle("fill",400,300, 280)
	love.graphics.setColor(0,0,0,1)
	love.graphics.setLineWidth(6)
	love.graphics.circle("fill", 400, 300, 6)
	love.graphics.line(400,300, math.cos(linePi)*275 + 400, math.sin(linePi)*275 +300 )
	linePi = linePi + math.pi/20
	if linePi >= math.pi*2 then
		linePi = 0
		piCounter = piCounter + 1
	end
	if piCounter >= 5 then nextStep() end
	--love.newImage("Cooking/table.png")
end



function part7( ... )
	playDing()
	love.graphics.draw(tablei,0,0)
	muffin =  love.graphics.newImage("Cooking/muffin.png")
	local w = 0
	local h = 0
	w,h = muffin:getDimensions()
	love.graphics.setColor(1,1,1,1)
	love.graphics.draw(muffin,400,300,0,1,1, w/2,h/2)
end


function drawMama( ... )

	-- if not canCut then
	--
	-- end
	collectgarbage()
	love.graphics.setNewFont("font.ttf", 20)

	if step == 1 then part1()
	elseif step == 2 then part2()
	elseif step == 3 then part3()
	elseif step == 4 then part4()
	elseif step == 5 then part5()
	elseif step == 6 then part6()
	elseif step == 7 then part7()
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

		 if step == 7 then return true end
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
		love.graphics.polygon("fill",i.baseX-10, i.baseY-10, i.baseX+10,i.baseY-10, i.baseX, i.baseY)
		love.graphics.line(i.baseX, i.baseY-5, i.baseX , i.baseY*1.75)
	elseif i.cut < 4 then
		--love.graphics.circle("line", i.x, i.y, i.w/2)
		love.graphics.polygon("fill",i.baseX+10,i.baseY,i.baseX-1, i.baseY+10, i.baseX-1, i.baseY-10)
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
		playChop()
		if maxMove <= 0 and maxMoveY - change >= -3 then
			maxMoveY = maxMoveY - change
			change = 1
		end
		--row = row - 3
	end
	--print(i.cut)
	return i.cut >=4
end


function playChop( ... )
	chop = love.audio.newSource("sound/chop.wav", "static")
	chop:isLooping(false)
	chop:play()
end







iPi = -math.pi
function createIngredients(size)
  --X =50
 X = math.cos(iPi)*rect.w +  rect.x*1.25
  if size == nil then size = 0 end
	for i=1,size do

		rectangle={
			x=X,
			baseX=X,
			y= math.sin(iPi)*rect.h +rect.y+1,
			baseY = math.sin(iPi)*rect.h +rect.y+1,
			w = 45,
			h=60,
			placed = false,
			dragging = { active = false, diffX = 0, diffY = 0 }
		}
		iPi = math.pi/5 + iPi
		 X = math.cos(iPi)*rect.w +  rect.x*1.25

		if #ingredients < size then
			table.insert(ingredients,rectangle)
		end
	end


end



crackedCounter=0
function crackEgg( ... )
	bowlLine = {x=200, y = 400, w=20, h =20}
	love.graphics.draw(love.graphics.newImage("Cooking/mix.png"),bowlLine.x-150,bowlLine.y)
	--love.graphics.rectangle("line", bowlLine.x, bowlLine.y, bowlLine.w, bowlLine.h)
	x,y = love.mouse.getPosition()
	
	for i=1,#eggs do 
		if eggs[i].hold then
			eggs[i].x = x
			eggs[i].y = y
		end

		--love.graphics.circle("line", eggs[i].x, eggs[i].y, eggs[i].r)
		
		--love.graphics.draw(love.graphics.newImage("Cooking/egg.png") ,eggs[i].x, eggs[i].y,0,eggs[i].r*2/eggs[i].r,eggs[i].r*2/eggs[i].r,eggs[i].r/2+8,eggs[i].r/2+8)
		love.graphics.draw(love.graphics.newImage("Cooking/egg.png") ,eggs[i].x, eggs[i].y,0,eggs[i].r*2/eggs[i].r,eggs[i].r*2/eggs[i].r,eggs[i].r/2+8,eggs[i].r/2+8)
		if ((eggs[i].x - eggs[i].r/2 >= bowlLine.x + bowlLine.w) or --to get a little more tht the edge of the egg
			   (eggs[i].x + eggs[i].r  <= bowlLine.x) or
			   (eggs[i].y - eggs[i].r>= bowlLine.y + bowlLine.h) or
			   (eggs[i].y + eggs[i].r <= bowlLine.y)) then
		 elseif eggs[i].hold then
		 	--print(egg.r)
		 	crackedCounter = crackedCounter + 1
		 	eggs[i].r = 0 -- remove egg
		 	eggs[i].hold = false
		 	--return true
		 end
	end

	--print(crackedCounter)
	if crackedCounter == #eggs then return true end
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
	  	--print("true")
	    ingredients[i].dragging.active = true
	    ingredients[i].dragging.diffX = x - ingredients[i].x
	    ingredients[i].dragging.diffY = y - ingredients[i].y

	  end
	end
end
for i = 1, #eggs do 
	if step == 2 then
		if ((eggs[i].x - eggs[i].r >= x) or
			   (eggs[i].x + eggs[i].r  <= x) or
			   (eggs[i].y - eggs[i].r>= y) or
			   (eggs[i].y + eggs[i].r <= y)) then
		 else
		 	eggs[i].hold = true
		 end
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
  --if button == 1 then rect.dragging.active = false end
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
