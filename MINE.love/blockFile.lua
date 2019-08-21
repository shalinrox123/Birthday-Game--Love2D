


block = {
	x = 0,
	y = 0,
	w = 0,
	h = 0,
	hit = 0,
	opacity = 1,
	frame = 1
}

collision = false
blockAmount = 5
blockCounter = 0

platforms= {}
brokenPlatforms= {}
brokenSprites={}
blockSprites = {}

spriteBlocks = {w = 16, h= 16}
initialB = 0
finalB = 0
findStartB = 16
findEndB = 16
blockFrame = blockSprites[1]


function makeBlocks()
	local block = {}
	local overlaps
	repeat
	
	block.x = love.math.random(spriteBlocks.w, width - spriteBlocks.w)
	block.y = 320
	block.w = 50
	block.h = 50
	block.hit = 0
	block.opacity = 1

	overlaps = false
	for i = 1,#platforms do
		if areBlocksOverlaping(block,platforms[i]) then
			overlaps = true
			break
		end
	end
	until(not overlaps)
	table.insert(platforms,block)
end

function areBlocksOverlaping(a,b)
	if ((b.x >= a.x + a.w + 5) or
		(b.x + b.w + 5 <= a.x) or
		(b.y >= a.y + a.h) or
		(b.y + b.h <= a.y)) then
		return false 
	else 
		return true
	end
end


function checkCollision(player)
	for i= 1, #platforms do

		
		collision = isColliding(platforms[i], player)
		hitOnTop = (isCollidingTop(platforms[i], player))
		hitOnBottom = (isCollidingBottom(platforms[i], player)) 
		--hitOnSide = (isCollidingSide(platforms[i], player)) 
		--print(collision, hitOnTop, player.y, player.y+player.h, platforms[i].y, platforms[i].y+5)

		if hitOnTop and grav > 0  then 
			player.y = platforms[i].y - player.h
			vel = 0
			grav = 0
			jumpCounter = 0
			onTop = false
			break 
		end

		if hitOnBottom  then 
			
			if platforms[i].hit < 5 then
				platforms[i].hit = platforms[i].hit + .5
				--print(math.floor(platforms[i].hit))
			end
			blockFrame = blockSprites[3]
			table.insert(brokenPlatforms, platforms[i])
			grav = math.abs(grav) -1
			--table.remove(platforms, i)
			--blockCounter = blockCounter - 1
			if player.y == ground then jumpCounter = 0 end
			break 
		end

		
		vel = initialVel

		
	end
end


--sprites

function getBlocksFromSheet( ... )
	blockSpreadSheet = love.graphics.newImage("img/MineCraftSpreadSheet.png")
	findStartB = 16
	findEndB = 16
	for col = 1,24 do
		for row = 1,24 do
			table.insert(blockSprites,love.graphics.newQuad(initialB,finalB,findStartB,findEndB, blockSpreadSheet:getDimensions()))
			initialB = initialB + spriteBlocks.w
		end
			initialB = 0
			finalB = finalB + spriteBlocks.h
	end

	brokenBlocks = love.graphics.newImage("img/blockBreakingSheet.png")

	initialB = 0
	finalB = 0
	findStartB = 64
	findEndB = 64
	for col = 1,2 do
		for row = 1,2 do
			table.insert(brokenSprites,love.graphics.newQuad(initialB,finalB,findStartB,findEndB, brokenBlocks:getDimensions()))
			initialB = initialB + 64
		end
			initialB = 0
			finalB = finalB + 64
	end

end

function breakBlock(p)
	if p.hit >= 5 then 
		p.opacity = 0
	end
	
end
-- function blockHitAnimation( ... )
-- 	number = love.math.random(0, 1)
-- 	if number == 1 then 
-- 		blockFrame = blockSprites[3]
-- 	else
-- 		blockblockFrame = blockSprites[4]
-- 		return
-- 	end

-- end