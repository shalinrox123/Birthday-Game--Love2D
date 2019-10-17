require "frames"

buttons={}

function createButton()
	button={
		x= love.graphics.getWidth()/2-30,
		y= love.graphics.getHeight()*2/3,
		w=60,
		h=30
	}

  if table.getn(buttons) == 0 then
	 table.insert(buttons, button)
  end
end

function drawButtons( ... )
	for i=1, table.getn(buttons) do
		 love.graphics.setColor(0,0,0, .5)
     love.graphics.rectangle("fill", buttons[i].x-3, buttons[i].y-3, buttons[i].w+6, buttons[i].h+6)
     love.graphics.setColor(1, 1, 1, 1)
     love.graphics.draw(love.graphics.newImage("button.png"), buttons[i].x-5, buttons[i].y-5)

  		--love.graphics.rectangle("fill", buttons[i].x, buttons[i].y, buttons[i].w, buttons[i].h)
		 end
end

function checkButton(x,y,click )
	for j=1 , table.getn(buttons) do
  		if click == 1 and releaseOver(x, y, buttons[j], buttons) then 

  			--works now clear button list, clear screen and go to next level
  			if currFrame == "ShopRite" then 
  				nextFrame()
  				blocks={}
  				square = {}
  				clearButton()
  			elseif currFrame == "iSpy" then
  				nextFrame()
  				values = {} 
  				boxes = {}
  				clearButton()
  				print("going to wario")
  			elseif currFrame == "wario" then
  				nextFrame()
  				clothes = {} 
  				body = {}
  				clearButton()
  				print("IT'S 4AM")
       elseif currFrame == "racing2" then
          nextFrame()
          Car = {} 
          map = {}
          car = {}
          boxSet = {}
          clearButton()
          print("The boys are online!")
         elseif currFrame == "discord" then
          nextFrame()
          posts = {} 
          lives = {}
          car = {}
          boxSet = {}
          clearButton()
          print("Hungry?")
          elseif currFrame == "cooking" then
          nextFrame()
          eggs = {} 
          SugaSprite = {}
          boxes = {}
          numpad = {}
          ingredients = {}
          clearButton()
          print("HAPPY BIRTHDAY ON THE BED!")
        end
		end
		end
end

function clearButton( ... )
	buttons={}
end