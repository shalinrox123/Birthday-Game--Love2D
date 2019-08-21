
require "playerFile" 
require "blockFile"
require "setting"
require "marioSprite"
require "mouseFile"
require "camera"


-- '''
-- ToDo:
-- fix side hit colision
-- coins?
-- block sprite
-- blocks not overlap
-- ground sprite
-- move/translate map
-- '''


local w
local h
w,h = love.window.getMode()

sprite = {w = 155, h = 155}
i = 1
marioPlayer = {
	x = 2*sprite.w + 40,
	y = 100,
	w = 155/2 -10,
	h = 155/2 - 5
}

luigiPlayer = {
	x = 4*sprite.w,
	y = 100,
	w= marioPlayer.w,
	h = marioPlayer.h
}
dt =0

-- counter = 1
-- i = 1

function love.load( ... )
	love.graphics.setDefaultFilter("nearest", "nearest") --sharp pixles
	getMarioFromSheet()
	getBlocksFromSheet()
	makeGround()
end
sky = love.graphics.newImage("img/sky.png")
function love.draw( )
	--love.graphics.setColor(unpack(color))
	camera:set()
	camera:setBounds(0, 0, sky:getWidth(),100) 

	camera:setPosition(marioPlayer.x - marioPlayer.w -w/2, marioPlayer.y + marioPlayer.y -h*2)

	love.graphics.getBackgroundColor(0,1,1)
	love.graphics.setColor(1,1,1,1)
	blocksSize = {0, 50/16,50/16}
	brokenSize={0,.75,.75}

	love.graphics.draw(sky,0,0,0,1.5,1.5)

	for i =1,#groundBlocks/2 do
		love.graphics.draw(blockSpreadSheet,blockSprites[4], groundBlocks[i].x, groundBlocks[i].y,unpack(blocksSize))
	end
	for i =#groundBlocks/2+1,#groundBlocks  do
		love.graphics.draw(blockSpreadSheet,blockSprites[3], groundBlocks[i].x, groundBlocks[i].y,unpack(blocksSize))
	end
	for i =1,#platforms do
		love.graphics.setColor(1,1,1,platforms[i].opacity)
		breakBlock(platforms[i])
		love.graphics.draw(blockSpreadSheet,blockSprites[49], platforms[i].x, platforms[i].y,unpack(blocksSize))
		if platforms[i].hit > 1 and platforms[i].hit < 5 then love.graphics.draw(brokenBlocks, brokenSprites[math.floor(platforms[i].hit)],platforms[i].x, platforms[i].y, unpack(brokenSize)) end

		if platforms[i].hit >= 5 then 
			platforms[i].w = 0
			platforms[i].h = 0
			platforms[i].y = 0
			platforms[i].y = 0
		end
		-- how to drop "gold" coin
	end
	love.graphics.setColor(1,1,1,1)
	love.graphics.draw(marioSpreadSheet,marioFrame, marioPlayer.x,marioPlayer.y,0,.5,.5)
	camera:unset()
end





function love.update(dt)
	--love.timer.sleep(.2)
	
	--isDown(1)
	blockSelect(platforms, brokenPlatforms)
	while blockCounter < blockAmount do
		makeBlocks()
		blockCounter = blockCounter + 1
	end

	for i = 1,#groundBlocks do
		if isColliding(marioPlayer,groundBlocks[i]) then
			marioPlayer.y = ground - marioPlayer.h
    		grav = 0
    		jumpCounter = 0
    	end
    end


	playerMove(marioPlayer)
	checkCollision(marioPlayer)
	checkGround(marioPlayer)
	animateMario()

	--luigi comes out when mario dies
	--reet all booleans when new char comes in ie in player file
	-- playerMove(luigiPlayer)
	-- checkCollision(luigiPlayer)
	-- checkGround(luigiPlayer)
	dt = dt + 1
end


