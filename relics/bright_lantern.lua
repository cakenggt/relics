local radius = 5

minetest.register_node("relics:bright_lantern", {
	description = "Bright Lantern",
	drawtype = "nodebox",
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = relics_helper.node_box_converter({
			{7, 9, 7, 9, 8, 9},
			{4, 8, 4, 12, 7, 12},
			{6, 7, 6, 10, 1, 10},
			{5, 1, 5, 11, 0, 11}
		})
	},
	use_texture_alpha = true,
	tiles = {
		{name = "relics_bright_lantern_top.png"},
		{name = "relics_bright_lantern_top.png"},
		{name = "relics_bright_lantern_side.png"},
		{name = "relics_bright_lantern_side.png"},
		{name = "relics_bright_lantern_side.png"},
		{name = "relics_bright_lantern_side.png"},
	},
	groups = {oddly_breakable_by_hand = 3},
	on_construct = function(pos)
		swap(pos, radius, "air", "relics:bright_lantern_light")
		minetest.get_node_timer(pos):start(10)
	end,
	on_destruct = function(pos)
		swap(pos, radius, "relics:bright_lantern_light", "air")
	end,
	on_timer = function(pos)
		swap(pos, radius, "air", "relics:bright_lantern_light")
	end
})

function swap(pos, radius, from, to)
	local vm1 = VoxelManip()
	local p1 = vector.subtract(pos, radius)
	local p2 = vector.add(pos, radius)
	local minp, maxp = vm1:read_from_map(p1, p2)
	local a = VoxelArea:new({MinEdge = minp, MaxEdge = maxp})
	local data = vm1:get_data()
	local c_from = minetest.get_content_id(from)
	local c_to = minetest.get_content_id(to)

	for z = pos.z - radius, pos.z + radius do
		for y = pos.y - radius, pos.y + radius do
			for x = pos.x - radius, pos.x + radius do
				local vi = a:index(x, y, z)
				local cid = data[vi]
				if cid == c_from then
					data[vi] = c_to
				end
			end
		end
	end

	vm1:set_data(data)
	vm1:write_to_map()
end

minetest.register_node("relics:bright_lantern_light", {
	drawtype = "airlike",
	sunlight_propagates = true,
	light_source = minetest.LIGHT_MAX,
	walkable = false,
	pointable = false,
	diggable = false,
	climbable = false,
	buildable_to = true,
	floodable = true,
	groups = {not_in_creative_inventory = 1}
})

table.insert(relics, {
	itemstring = "relics:bright_lantern",
	ceil = -1500,
	floor = -2500
})
