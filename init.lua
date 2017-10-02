mod_storage = minetest.get_mod_storage()

relics = {}

relicfiles = {
	--"watch", -- doesn't work
	"portable_hole",
	"universal_solvent",
	"strange_compass"
}

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
	after_dig_node = function (pos, oldnode, oldmetadata, digger)
		local dropped = get_random_appropriate_relic(pos.y)
		if dropped ~= nil then
			minetest.handle_node_drops(pos, {dropped.name.." 1"}, digger)
		end
	end,
	groups = {cracky = 2}
})

minetest.register_ore({
	ore_type = "scatter",
	ore = "relics:relic_ore",
	wherein = "default:stone",
	clust_scarcity = 21 * 21 * 21,
	clust_num_ores = 1,
	clust_size = 1,
	y_max = 0
})
