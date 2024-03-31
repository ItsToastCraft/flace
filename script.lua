--data api!!!
config:setName("Flace")
local player_name = avatar:getEntityName()
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


local skull = deepCopy(head)
skull:removeChild(skull.Head)
skull:setParentType("None")
model.Skull:addChild(skull)



-- hats --
local hats = {
	{ head.FarmerHat,   "Farmer Hat", skull.FarmerHat},
	{ head.Goggles,     "Goggles", skull.Goggles},
	{ head.BaseballCap, "Baseball Cap", skull.BaseballCap },
	{ head.Crown,       "Crown", skull.Crown },
	{ head.MushroomHat, "Mushroom Hat", skull.MushroomHat },
	{ head.ChefHat,     "Chef Hat", skull.ChefHat },
	{ head.GNHat,       "GN's Hat", skull.GNHat},
	{ head.WitchHat,    "Witch Hat", skull.WitchHat },
	{ head.Het,         "Het", skull.Het },
}

local currentHat = config:load("hat") or 0

function pings.setHat(x)
	x = x or 0
	currentHat = x
	for i, v in pairs(hats) do
		v[1]:setVisible(i == x)
	end
	--het:setPos(hetPlace[x].pos)
	--het:setRot(hetPlace[x].rot)
	config:save("hat", x)
end

pings.setHat(currentHat)

-- pings --

A = function(x) print(x) end

local pingsRefresh = {
	tickDelay = 50,
	{ pings.setHat, _G, "currentHat" },
}
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
		:setOnLeftClick(function()
			action_wheel:setPage(pages[(index % #pages) + 1])
			index = index + 1
		end)

	pages[math.floor(i / 7) + 1]:newAction((i % 7) + 1)
		:setItem("player_head{SkullOwner:" .. "ItsToastCraft" .. ",Data:" .. i .. "}")
		:setTitle(hats[i][2])
		:setOnLeftClick(function() pings.setHat(i) end)
	pages[math.floor(i / 7) + 1]:newAction(8)

	:setTexture(textures.texture, 96, 0, 16, 16, 1)
		:setTitle("Previous Page")
		:setOnLeftClick(function()
			action_wheel:setPage(pages[(index % #pages) + 1])
			index = index - 1
		end)
end


function events.skull_render(a, b, c, d, e)
	if c ~= nil then
		data = c["tag"]["Data"] or currentHat
		if data == nil then
			data = currentHat
		end
		for i, v in pairs(hats) do
			v[3]:setVisible(data == i)
		end
	end
		skull:setScale(e=="HEAD" and 0.85 or 1)
		skull:setPos(0,e == "BLOCK" and -30 or e == "HEAD" and -24 or -32 ,0)
end


--   tick   --
function events.render()
	--variables--

	local worldTime = world.getTime()

	if worldTime % 200 == 0 then
		pings.setHat(currentHat)
	end

	if lhat ~= currentHat then
		nameplate.ENTITY:setPos(0, currentHat == 0 and 0 or 0.4, 0)
		lhat = currentHat
	end
end
