local radius = 10
local uses = 128

local names = {
	"relics:relic_ore",
	"default:stone_with_diamond",
	"default:stone_with_mese",
	"default:stone_with_gold",
	"default:stone_with_tin",
	"default:stone_with_copper",
	"default:stone_with_iron",
	"default:stone_with_coal"
}

minetest.register_tool("relics:strange_compass", {
	description = "Strange Compass",
	inventory_image = "relics_strange_compass.png",
	wield_image = "relics_strange_compass.png",
	on_use = function(itemstack, user, pointed_thing)
		local user_pos = user:get_pos()
		for i, name in ipairs(names) do
			local node = minetest.find_node_near(user_pos, radius, {name}, true)
			if node ~= nil then
				local origin = vector.new(user_pos.x, user_pos.y+1.6, user_pos.z)
				relics_helper.particle_travel(origin, node, "relics_strange_compass_particle.png", minetest.LIGHT_MAX, vector.distance(origin, node))
				break
			end
		end
		itemstack:add_wear(65535/uses)
		return itemstack
	end
})

table.insert(relics, {
	itemstring = "relics:strange_compass",
	ceil = -500,
	floor = -2000
})
