mod_storage = minetest.get_mod_storage()

relics = {}

relicfiles = {
	--"watch", -- doesn't work
	"portable_hole",
	"universal_solvent",
	"strange_compass",
	"second_glass",
	"repair_paste",
	"flakey_pick",
	"glass_heart",
	"bright_lantern"
}

relics_helper = {}

relics_helper.particle_travel = function(start, stop, image, glow, time)
	local direction = vector.direction(start, stop)
	minetest.add_particle({
		pos = start,
		velocity = vector.divide(vector.multiply(vector.normalize(direction), vector.distance(start, stop)), time),
		expirationtime = time,
		texture = image,
		glow = glow
	})
end

function map(func, array)
  local new_array = {}
  for i,v in ipairs(array) do
    new_array[i] = func(v)
  end
  return new_array
end

-- allows you to define node boxes using the numbers 0-16 as the
-- corner positions of the boxes
relics_helper.node_box_converter = function(def)
	if type(def) == "table" then
		return map(relics_helper.node_box_converter, def)
	else
		return -0.5 + (def/16)
	end
end

for i, relic in ipairs(relicfiles) do
	dofile(minetest.get_modpath("relics").."/relics/"..relic..".lua")
end

function get_random_appropriate_relic(level)
	local appropriate_relics = {}
	for i, relic in ipairs(relics) do
		if (relic.ceil == nil or relic.ceil >= level) and (relic.floor == nil or relic.floor <= level) then
			table.insert(appropriate_relics, relic)
		end
	end
	if #appropriate_relics == 0 then
		return nil
	else
		return appropriate_relics[math.random(#appropriate_relics)]
	end
end

minetest.register_node("relics:relic_ore", {
	description = "Relic Ore",
	tiles = {"default_stone.png^relics_relic_ore.png"},
	drop = "",
	after_dig_node = function (pos, oldnode, oldmetadata, digger)
		local dropped = get_random_appropriate_relic(pos.y)
		if dropped ~= nil then
			minetest.handle_node_drops(pos, {dropped.itemstring}, digger)
		end
	end,
	groups = {cracky = 2}
})

-- twice as common between 0 and -1000 as -1000 and below
minetest.register_ore({
	ore_type = "scatter",
	ore = "relics:relic_ore",
	wherein = "default:stone",
	clust_scarcity = 21 * 21 * 21,
	clust_num_ores = 1,
	clust_size = 1,
	y_max = 0
})

minetest.register_ore({
	ore_type = "scatter",
	ore = "relics:relic_ore",
	wherein = "default:stone",
	clust_scarcity = 21 * 21 * 21,
	clust_num_ores = 1,
	clust_size = 1,
	y_max = 0,
	y_min = -1000
})
