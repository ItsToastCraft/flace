--data api!!!
config:setName("Flace")

-- some vanilla stuff --
vanilla_model.HEAD:setVisible(false) -- You can hide this line if you're using this with another model, just make sure that the head on that model is rendered first
vanilla_model.HELMET:setVisible(false)
vanilla_model.CAPE:setVisible(false)
vanilla_model.HELMET_ITEM:setVisible(true)

local function deepCopy(model)
	local copy = model:copy(model:getName())
	for _, child in pairs(copy:getChildren()) do
		copy:removeChild(child):addChild(deepCopy(child))
	end
	return copy
end
--variables --
ping = {}
local lhat = 0
-- some model stuff --
local model = models.model
local head = model.Head
animations.model.speeen:play()
animations.model.speeen:setSpeed(math.pi)

head.Head:setPrimaryTexture("SKIN")
head.Head:setPrimaryRenderType("CUTOUT_CULL")
head.Het:setScale(1.4, 1.4, 1.4)

avatar:store("env", _ENV)

local skull = deepCopy(head)
skull:removeChild(skull.Head)
skull:setParentType("None")
model.Skull:addChild(skull)


-- hats --
local hats = {
	{ head.FarmerHat,   "Farmer Hat",   skull.FarmerHat,   "#d8af3c" },
	{ head.Goggles,     "Goggles",      skull.Goggles,     "#ffe792" },
	{ head.BaseballCap, "Baseball Cap", skull.BaseballCap, "#d4362b" },
	{ head.Crown,       "Crown",        skull.Crown,       "#f3b040" },
	{ head.MushroomHat, "Mushroom Hat", skull.MushroomHat, "#f25941" },
	{ head.ChefHat,     "Chef Hat",     skull.ChefHat,     "fffef9" },
	{ head.GNHat,       "GN's Hat",     skull.GNHat,       "#3b932a" },
	{ head.WitchHat,    "Witch Hat",    skull.WitchHat,    "#8f27d1" },
	{ head.Het,         "Het",          skull.Het,         "#a247b8 " },
}

local currentHat = config:load("hat") or 0

function pings.setHat(x)
	x = x or 0
	currentHat = x
	for i, v in pairs(hats) do
		v[1]:setVisible(i == x)
	end
	config:save("hat", x)
end

pings.setHat(currentHat)

-- pings --

A = function(x) print(x) end

local pages = { action_wheel:newPage("hat1") }
local index = 1
action_wheel:setPage(pages[index])

-- action wheel --
for i = 1, #hats do
	if i % 9 == 1 then
		table.insert(pages, action_wheel:newPage("hat" .. i % 9 + 1))
	end

	pages[math.floor(i / 7) + 1]:newAction(1)
		:setTexture(textures.texture, 112, 0, 16, 16, 1)
		:setTitle("Next Page")
		:setColor(vectors.hexToRGB("#3764b1"))
		:setOnLeftClick(function()
			action_wheel:setPage(pages[(index % #pages) + 1])
			index = index + 1
		end)

	pages[math.floor(i / 7) + 1]:newAction((i % 7) + 1)
		:setItem("player_head{SkullOwner:" .. "ItsToastCraft" .. ",Data:" .. i .. "}")
		:setTitle(hats[i][2])
		:setOnLeftClick(function() pings.setHat(i) end)
		:setColor(vectors.hexToRGB(hats[i][4]))
	pages[math.floor(i / 7) + 1]:newAction(8)

		:setTexture(textures.texture, 96, 0, 16, 16, 1)
		:setTitle("Previous Page")
		:setColor(vectors.hexToRGB("#3764b1"))
		:setOnLeftClick(function()
			action_wheel:setPage(pages[(index % #pages) + 1])
			index = index - 1
		end)
end


function events.skull_render(delta, blockstate, itemStack, entity, type)
	if itemStack ~= nil then
		data = itemStack["tag"]["Data"] or currentHat
		if data == nil then
			data = currentHat
		end
		for i, v in pairs(hats) do
			v[3]:setVisible(data == i)
		end
	end
	skull:setScale(type == "HEAD" and 0.85 or 1)
	skull:setPos(0, type == "BLOCK" and -30 or type == "HEAD" and -24 or -32, 0)
end

--   tick   --
function events.render()
	--variables--

	local worldTime = world.getTime()

	if worldTime % 200 == 0 then
		pings.setHat(currentHat)
	end

	if lhat ~= currentHat then
		lhat = currentHat
	end
end
