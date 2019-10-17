

local my = 300
local buffer = 5
love.math.setRandomSeed( love.timer.getTime() )
posts= { }
T = 0
time = 0
totalNSFW = 0
score = 0
finished = false

function createPosts( ... )
	y= 100
	for i=1,15 do
		e = love.math.random(20, 100)
		local post = {x=290, 
				y=y-e, 
				w=470, 
				h=e,
				color={.5,.5,.5},
				p=false}
		y = post.y - buffer
		table.insert(posts, post)
	end
	for i = 1,4 do 
		x= love.math.random(#posts)
		posts[x].p = true
		posts[x].color = {.5,0,.5}
	end
end

life = 0
local bg = love.graphics.newImage('plainBG.png')

lives = {
	{"fill", 103,277, 170,40},
	{"fill", 103,230, 170,40},
	{"fill", 103,195, 175,40},
	{"fill", 103,155, 170,40}

}

local prevTime = love.timer.getTime()
local text = "Remove all the NSFW posts on the\nserver as fast as you can in 30 \nseconds. you must remove all the \nNSFW posts and have a score over 20. \nbe careful, if you remove the wrong \nposts your friends will leave the \nserver. \n\nif you loose all your friends or the \ntime runs out you will have to start \nover. \n\nthe NSFW posts are colored.\n\ndont forget to scroll :)"
local ready = false
local function frame1( ... )
	love.graphics.setNewFont("font.ttf", 20)	
	love.graphics.print(text,30, 30)
	love.graphics.print("Press start",300, 500)
	if love.keyboard.isDown("return") then 
		ready=true 
		prevTime = love.timer.getTime()
	end
end

local function frame2( ... )

	love.graphics.setColor(1,1,1,1)
	love.graphics.draw(bg,20,20,0, .4,.4)


	love.graphics.setColor(45/255,49/255,53/255,1)


	for i= 1, life do
		love.graphics.rectangle(unpack(lives[i]))
	end
	if love.timer.getTime()-prevTime <= 30 then
		love.graphics.setColor(1,1,1,1)
		--love.graphics.setNewFont("font.ttf", 20)
		
			love.graphics.setNewFont("font.ttf", 33)
			love.graphics.print(math.floor(love.timer.getTime()-prevTime).."s", 120, 50)
			love.graphics.setNewFont("font.ttf", 25)
			love.graphics.print(score, 30, 50)
		

		for i= 1,table.getn(posts) do 
			love.graphics.setColor(posts[i].color,1)
			love.graphics.rectangle("fill", posts[i].x, posts[i].y, posts[i].w, posts[i].h)
			love.graphics.setColor(1,1,1,1)
		end
		love.graphics.setColor(1,1,1,1)

		love.graphics.polygon('fill', 20, 485, 775, 485, 900,  900, -100, 900)
		love.graphics.setColor(.6,0,.4,.3)
		love.graphics.setNewFont("font.ttf", 33)
		love.graphics.print("k  a  y  b  o  a  r  d", 30, 490, 0,1, 2)
		-- body
	end
end

function frame3( ... )
	love.graphics.setNewFont("font.ttf", 20)	
	text = "Now i hope you understand how awful \nit is to keep a clean server with \nGayson and you\n\nOkay but this game was pretty \nfun to make"
	love.graphics.print(text,30, 30)

end

function drawScreen( ... )
	collectgarbage()
	if not ready then frame1() end
	if ready  and not finished then frame2() end 
	if ready and finished then frame3() end
end



function restart( ... )
 posts ={}
 T = 0
 prevTime = love.timer.getTime()
 life = 0
 score = 0
 totalNSFW = 0
end

function updateScreen( ... )
	if ready then

	if life >= 4 or love.timer.getTime()-prevTime >= 30 then restart() end


if life < 4 then
	if T == 0 then
	 createPosts()
	 T = 1
	end

	for i=1, table.getn(posts) do 
    	if posts[1].y + posts[1].h + 5< 485 then
    		posts[i].y = posts[i].y + 5 
    	end
	end

	checkSpace()

	if math.floor(time%100) == 0 and #posts < 30 and score < 20 then 
		for i=1,love.math.random(7, 15) do createNewPost() end
	end

	time = time + 1

		--make sure all posts are clean
	local isTrue = 0
	for i=1, #posts do
		if posts[i].p then isTrue = isTrue + 1 end
	end

	function love.wheelmoved( dx, dy )
	    for i=1, table.getn(posts) do 
	    	if not ( posts[1].y + posts[1].h + dy < 485) then
	     		posts[i].y = posts[i].y + (dy*10)
	     	end
	     end
	end
	

	if isTrue == 0 and score >= 20 then 
		finished = true
		return true 
	end

end


	
	
end
end






function createNewPost( ... )
		e = love.math.random(20, 100)
		local post = {x=290, 
				y=posts[1].y + posts[1].h + buffer, 
				w=470, 
				h=e,
				color={.5,.5,.5},
				p=false}
		
	local e = love.math.random(5) 

	if e > 2 and totalNSFW < 20 then 
		post.p = true
		post.color = {.5,0,.5}
		totalNSFW = totalNSFW + 1
	end

	table.insert(posts, 1, post)
	while posts[1].y + posts[1].h > 485 do
		for i=1, table.getn(posts) do 
    			posts[i].y = posts[i].y - 5 
    		end
		end
end
function clickPost(mx,my,button)

	if life < 4 then
mouse = {x=mx,y=my}
	for i=1, table.getn(posts) do 
		if collide(mouse, posts[i]) then
			if not posts[i].p == true then
			 life = life + 1 
			 score = score - 3
			end
			table.remove(posts,i)
			score = score + 1
			return
		end
	end
	end
end

function checkSpace( ... )
	for i=1,table.getn(posts)-1 do
		if posts[i].y - (posts[i+1].y + posts[i+1].h) > buffer then
			posts[i+1].y = posts[i+1].y + 5
		end
	end
end

function collide(a,b)
	   if ((b.x >= a.x + carImage:getWidth()/2) or
		   (b.x + b.w <= a.x) or
		   (b.y >= a.y + carImage:getHeight()/2) or
		   (b.y + b.h <= a.y)) then
			  return false 
	   else return true end
	end




