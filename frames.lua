
frames = {"ShopRite", "iSpy", "wario", "racing2", "discord", "cooking"}
frameValue = 1
currFrame = frames[frameValue]

function nextFrame( ... )
	frameValue = frameValue + 1
	currFrame = frames[frameValue] 
end