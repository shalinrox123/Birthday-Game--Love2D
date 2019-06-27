
frames = {"ShopRite", "iSpy", "wario"}
frameValue = 1
currFrame = frames[frameValue]

function nextFrame( ... )
	frameValue = frameValue + 1
	currFrame = frames[frameValue] 
end