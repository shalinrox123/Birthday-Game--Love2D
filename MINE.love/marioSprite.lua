
require "playerFile"

sprite = {w = 155, h = 155}
initial = 0
final = 0
findStart = sprite.w
findEnd = sprite.h
marioSprites = {}
marioRight = {}
marioLeft= {}
marioFrame = nil
i = 0
j = 2


function getMarioFromSheet()
	marioSpreadSheet = love.graphics.newImage("img/SteveSheet.png")
	for i = 1,3 do
		for j = 1,4 do
			table.insert(marioSprites,love.graphics.newQuad(initial,final,findStart,findEnd, marioSpreadSheet:getDimensions()))
			initial = initial + sprite.w
		end
			initial = 0
			final = final + sprite.h + 2
	end

	table.remove(marioSprites, #marioSprites)
	table.remove(marioSprites, #marioSprites)
	marioFrame = marioSprites[9]
	sortMario()

end

function sortMario()
	marioRight = {marioSprites[9],marioSprites[1],marioSprites[2],marioSprites[1],marioSprites[3],marioSprites[4]}
	marioLeft = {marioSprites[10], marioSprites[5],marioSprites[6],marioSprites[5],marioSprites[7], marioSprites[8]}
end


function animateMario()
	--print(wasLeft, left)
	if  wasRight and jumpCounter > 0 then 
		marioFrame = marioRight[6]
	elseif wasRight and not right then
		marioFrame = marioRight[2]
		j = 2
	elseif right then
		marioFrame = marioRight[j]
		i = i + 1
		if i %10 == 0 then j = j + 1 end
		if j > 5 then j = 2 end
	
	end

	
	if  wasLeft and jumpCounter > 0 then 
		marioFrame = marioLeft[6]
	elseif wasLeft and not left then
		marioFrame = marioLeft[2]
		j = 2
	elseif left then
		marioFrame = marioLeft[j]
		i = i + 1
		if i %10 == 0 then j = j + 1 end
		if j > 5 then j = 2 end
	end


end
