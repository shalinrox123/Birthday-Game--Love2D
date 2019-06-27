local shader_code = [[
#define NUM_LIGHTS 32

struct Light{
	vec2 position;
	vec3 diffuse;
	float power;
};


extern Light lights[NUM_LIGHTS];
extern int num_lights;
extern vec2 screen;

const float constant = 1.0;
const float linear = 0.09;
const float quadratic = 0.032;


vec4 effect(vec4 color, Image image, vec2 uvs, vec2 screen_coords){
	vec4 pixel = Texel(image, uvs);
	vec2 norm_screen = screen_coords/screen;
	vec3 diffuse = vec3(0);
	
	for (int i = 0; i < num_lights; i++){
		Light light = lights[i];
		
		vec2 norm_pos = light.position/screen;

		float distance = length(norm_pos - norm_screen) * light.power;
		float atten = 1/(constant + linear * distance + quadratic * (distance * distance) );


		diffuse += light.diffuse * (atten * atten)/1.25;
	}

	diffuse = clamp(diffuse, 0, 1);

	return vec4(diffuse, 1) * pixel;
}


]]
	

	--diffuse += light.diffuse * (atten * atten)/1.25;

light = {
	x = -200,
	y = -200,
	w = 150,
	h = w,
	a=0
}

local shader = nil
local image = nil
boxes = { {512, 151, 593, 147, 594, 161, 514, 164}, -- honey buns
		  {54, 490, 70, 518, 106, 489, 75, 470}, -- briefs
		  {733, 565, 752, 559, 768, 583, 744, 591}, -- monkey ball
		  {15, 363, 31, 357, 33, 371, 20, 375}, -- cards
		  {245, 399, 242, 439, 357, 465, 360, 423}, -- duckie 
		  {423, 445, 424, 454, 496, 469, 499, 458} -- war hammer 40k book
		}

values = {1,2,3,4,5,6}

whiteBoard = {165, 243, 165, 297, 110, 307, 108,250} -- white board


function makeiSpy( ... )
	image = love.graphics.newImage("room.png")
	shader = love.graphics.newShader(shader_code)
	love.mouse.setVisible(false)

end

function drawiSpy( ... )

	if not checkValues() then
		love.graphics.setShader(shader)
		shader:send("screen", {love.graphics.getDimensions()})

		

		shader:send("num_lights", 2)
		shader:send("lights[0].position", { love.mouse.getPosition()})
		shader:send("lights[0].diffuse", {1,1,1})
		shader:send("lights[0].power", 96) --128 or 96?


		shader:send("lights[1].position", { 70,20})
		shader:send("lights[1].diffuse", {1,1,1})
		shader:send("lights[1].power", 64) --128 or 96?

		--love.graphics.setColor(1,0,0,1)
		
		love.graphics.setShader(shader)
	else
		love.mouse.setVisible(true)
		love.graphics.setShader(shader)
		shader:send("screen", {love.graphics.getDimensions()})
		love.graphics.draw(image, 0, 0, 0, .5, .5)
		shader:send("num_lights", 0)
		shader = nil
		love.graphics.setShader(shader)
	end


	love.graphics.draw(image, 0, 0, 0, .5, .5)
	love.graphics.setNewFont("font.ttf", 12)
	if values[1] > 0 then love.graphics.print("Honey Buns", 5, 40,0,1,1) end
	if values[2] > 0 then love.graphics.print("Briefs", 5, 55,0,1,1) end
	if values[3] > 0 then love.graphics.print("Monkey Ball Game", 5, 70,0,1,1) end
	if values[4] > 0 then love.graphics.print("Box of Cards", 5, 85,0,1,1) end 
	if values[5] > 0 then love.graphics.print("Duckie", 5, 100,0,1,1) end
	if values[6] > 0 then love.graphics.print("War Hammer 40K", 5, 115,0,1,1) end 


	
end

function drawBoxes( )
	love.graphics.setColor(0,0,0,0)
	love.graphics.polygon("fill", unpack(boxes[5]))
end

function withinRange(box, mx, my)
	
	xVal = {box[1], box[3], box[5], box[7]}
	yVal = {box[2], box[4], box[6], box[8]}

	maxX = math.max(unpack(xVal))
	minX = math.min(unpack(xVal))

	maxY = math.max(unpack(yVal))
	minY = math.min(unpack(yVal))

	--print(box[1], box[2], box[3], box[4], box[5], box[6], box[7], box[8])
	if mx <= maxX and mx >= minX then
		if my < maxY and my >= minY then
			return true
		end
	end
end


function checkBoxes()
	x,y =love.mouse.getPosition( )
	for i=1, table.getn(boxes) do
		if withinRange(boxes[i], x,y) and values[i] > 0 then
			return true, i
		end
	end
end

function removeShader( ... )
	shader = nil
end



function checkValues( ... )
	amount = 0
	for i=1, table.getn(values) do
		if values[i] == 0 then amount = amount + 1 end
	end
	--amount = 6 -- get rid of this after debugging
	if amount == 6 then 
		return true 
	end
end










