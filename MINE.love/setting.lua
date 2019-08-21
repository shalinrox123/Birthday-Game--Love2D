

block={x=0,
			y=0,
			w=0,
			h=0}

groundBlocks={}
ground = 500
grav = 0
vel = 1


breaking = false
jumpVel = -4
initialVel = 1
color = {1,1,1}

--width, height = love.graphics.getDimensions()
sky = love.graphics.newImage("img/sky.png")
width = sky:getWidth()*2
local blockAmount = 0
local groundLimit = ground - 50

function makeGround()

	while blockAmount <= width do
		local block ={}
		block.x = blockAmount
		block.y = ground
		block.w = 50
		block.h = 50
		table.insert(groundBlocks,block)
		blockAmount = blockAmount + 50
	end

	blockAmount = 0
	while blockAmount <= width do
		local block ={}
		block.x = blockAmount
		block.y = ground + 50
		block.w = 50
		block.h = 50
		table.insert(groundBlocks,block)
		blockAmount = blockAmount + 50
	end
	print(#groundBlocks)
end