

local wasDown = false

function isDown(button)
	return love.mouse.isDown(button)
end

function isWithin(block)
	local mx, my = love.mouse.getPosition()
	if ((mx >= block.x + block.w ) or
		(mx <= block.x) or
		(my >= block.y + block.h) or
		(my <= block.y)) then
		return false 
	else 
		return true
	end
end

function blockSelect(fromArr, toArr)

	if isDown(1) then
		for i = 1, #fromArr do
			if isWithin(fromArr[i]) then 
				if fromArr[i].hit < 5 and not wasDown then 
					fromArr[i].hit = fromArr[i].hit + 1 
					print("hit")
					wasDown = isDown(1)
				end
				table.insert(toArr, fromArr[i])
			end
		end
	end
	wasDown = isDown(1)
end



