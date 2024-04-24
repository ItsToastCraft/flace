--data api!!!
config:setName("Flace")

-- some vanilla stuff --
vanilla_model.HEAD:setVisible(false) -- You can hide this line if you're using this with another model, just make sure that the head on that model is rendered first
vanilla_model.ALL:setVisible(false)
vanilla_model.HELMET:setVisible(false)
vanilla_model.CAPE:setVisible(false)
vanilla_model.HELMET_ITEM:setVisible(true)

-- 4P5's deepCopy function
local function deepCopy(model)
	local copy = model:copy(model:getName())
	for _, child in pairs(copy:getChildren()) do
		copy:removeChild(child):addChild(deepCopy(child))
	end
	return copy
end

--variables --
local hat = 0
-- some model stuff --
local model = models.model
local head = model.Head
animations.model.speeen:play()
animations.model.speeen:setSpeed(math.pi)

head.Head:setPrimaryTexture("SKIN")
head.Head:setPrimaryRenderType("CUTOUT_CULL")
head.Het:setScale(1.4, 1.4, 1.4)

local skull = deepCopy(head)
skull:removeChild(skull.Head)
skull:setParentType("None")
model.Skull:addChild(skull)


-- hats --
local hats = {
	{ head.None,        "None",         skull.None,        "#973131" },
	{ head.FarmerHat,   "Farmer Hat",   skull.FarmerHat,   "#d8af3c" },
	{ head.Goggles,     "Goggles",      skull.Goggles,     "#ffe792" },
	{ head.BaseballCap, "Baseball Cap", skull.BaseballCap, "#d4362b" },
	{ head.Crown,       "Crown",        skull.Crown,       "#f3b040" },
	{ head.MushroomHat, "Mushroom Hat", skull.MushroomHat, "#f25941" },
	{ head.ChefHat,     "Chef Hat",     skull.ChefHat,     "fffef9" },
	{ head.GNHat,       "GN's Hat",     skull.GNHat,       "#3b932a" },
	{ head.WitchHat,    "Witch Hat",    skull.WitchHat,    "#8f27d1" },
	{ head.Het,         "Het",          skull.Het,         "#a247b8 " },
	{ head.CRT,         "CRT Monitor",  skull.CRT,         "#696a6a " }
}

local currentHat = config:load("hat") or 0

-- pings -- 
function pings.setHat(x)
	x = x or 0
	currentHat = x
	for i, v in pairs(hats) do
		v[1]:setVisible(i == x)
	end
	config:save("hat", x)
end

pings.setHat(currentHat)

-- action wheel --
local pages = { action_wheel:newPage("hat") }
local buttonColor = "#3764b1"

local main = action_wheel:newPage("main")
main:newAction()
	:setTitle("Hats")
	:setItem("leather_helmet{display:{color:9908529}}")
	:setColor(vectors.hexToRGB("#973131"))
	:setOnLeftClick(function() action_wheel:setPage(pages[1]) end)
action_wheel:setPage(main)

function events.entity_init()
	for i = 1, #hats do
		if i % 7 == 0 then -- Adjusted the condition to start a new page
			table.insert(pages, action_wheel:newPage("hat"))
		end

		local pageIndex = math.floor(i / 7) + 1

		local slot = ((i - 1) % 6) + 2
		pages[pageIndex]:newAction(1)
			:setTexture(textures.texture, 112, 0, 16, 16, 1)
			:setTitle("Next Page")
			:setColor(vectors.hexToRGB(buttonColor))
			:setOnLeftClick(function()
				action_wheel:setPage(pages[(pageIndex % #pages) + 1])
			end)

		pages[pageIndex]:newAction(slot)
			:setItem("player_head{SkullOwner:" .. player:getName() .. ",Data:" .. i .. "}")
			:setTitle(hats[i][2])
			:setOnLeftClick(function() pings.setHat(i) end)
			:setColor(vectors.hexToRGB(hats[i][4]))

		if pageIndex == 1 then
			pages[1]:newAction(8)
				:setTexture(textures.texture, 112, 16, 16, 16, 1)
				:setTitle("Home")
				:setColor(vectors.hexToRGB(buttonColor))
				:setOnLeftClick(function()
					action_wheel:setPage(main)
				end)
		else
			pages[pageIndex]:newAction(8)
				:setTexture(textures.texture, 96, 0, 16, 16, 1)
				:setTitle("Previous Page")
				:setColor(vectors.hexToRGB(buttonColor))
				:setOnLeftClick(function()
					action_wheel:setPage(pages[((pageIndex - 2) % #pages) + 1])
				end)
		end
	end
end

function events.skull_render(delta, blockstate, itemStack, entity, type)
	if itemStack ~= nil then
		local data = itemStack["tag"]["Data"] or currentHat
		for i, v in pairs(hats) do
			v[3]:setVisible(data == i)
		end
	end
	skull:setScale(type == "HEAD" and 0.85 or 1)
	skull:setPos(0, type == "BLOCK" and -30 or type == "HEAD" and -24 or -32, 0)
end

-- tick --
function events.tick()
	--variables--
	local worldTime = world.getTime()

	if worldTime % 200 == 0 then
		pings.setHat(currentHat)
	end
end
