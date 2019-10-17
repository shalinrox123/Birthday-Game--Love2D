
frames = {"ShopRite", "wario", "racing2", "iSpy", "discord", "cooking", "fin"}
frameValue = 1
currFrame = frames[frameValue]

function nextFrame( ... )
	frameValue = frameValue + 1
	currFrame = frames[frameValue] 
end