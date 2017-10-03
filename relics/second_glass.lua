local node_box = {
	type = "fixed",
	fixed = {
		{-0.3125, -0.5, -0.3125, 0.3, -0.4375, 0.3},
		{-0.25, -0.4376, -0.25, 0.25, -0.0625, 0.25},
		{-0.0625, -0.0624, -0.0625, 0.0625, 0.0624, 0.0625},
		{-0.25, 0.0625, -0.25, 0.25, 0.4376, 0.25},
		{-0.3125, 0.4375, -0.3125, 0.3125, 0.5, 0.3125}
	}
}

function generate_on_timer(node_name)
	return function(pos, elapsed)
		local below = vector.new(pos.x, pos.y-1, pos.z)
		local below_timer = minetest.get_node_timer(below)
		local prev_timeout = below_timer:get_timeout()
		local prev_elapsed = below_timer:get_elapsed()
		if below_timer:is_started() then
			local callback = minetest.registered_nodes[minetest.get_node(below).name].on_timer
			if callback ~= nil then
				below_timer:stop() -- stop timer so that timer can reset itself if it wants to
				local result = callback(below, below_timer:get_elapsed())
				if result == true then -- if it returned true, reset it manually
					below_timer:set(prev_timeout, prev_elapsed)
				end
			end
		end
		minetest.swap_node(pos, {name = node_name})
		return true
	end
end

minetest.register_node("relics:second_glass", {
	description = "Second Glass",
	drawtype = "nodebox",
	paramtype = "light",
	node_box = node_box,
	use_texture_alpha = true,
	tiles = {
		{name = "relics_second_glass_top.png", backface_culling = false},
		{name = "relics_second_glass_top.png", backface_culling = false},
		{name = "relics_second_glass_side_a.png", backface_culling = false},
		{name = "relics_second_glass_side_a.png", backface_culling = false},
		{name = "relics_second_glass_side_a.png", backface_culling = false},
		{name = "relics_second_glass_side_a.png", backface_culling = false}
	},
	groups = {oddly_breakable_by_hand = 3},
	on_timer = generate_on_timer("relics:second_glass_b"),
	on_construct = function(pos)
		minetest.get_node_timer(pos):start(1.0)
	end,
	on_destruct = function(pos)
		minetest.get_node_timer(pos):stop()
	end
})

minetest.register_node("relics:second_glass_b", {
	description = "Second Glass",
	drawtype = "nodebox",
	paramtype = "light",
	node_box = node_box,
	use_texture_alpha = true,
	tiles = {
		{name = "relics_second_glass_top.png", backface_culling = false},
		{name = "relics_second_glass_top.png", backface_culling = false},
		{name = "relics_second_glass_side_b.png", backface_culling = false},
		{name = "relics_second_glass_side_b.png", backface_culling = false},
		{name = "relics_second_glass_side_b.png", backface_culling = false},
		{name = "relics_second_glass_side_b.png", backface_culling = false}
	},
	groups = {oddly_breakable_by_hand = 3, not_in_creative_inventory = 1},
	on_timer = generate_on_timer("relics:second_glass"),
	on_construct = function(pos)
		minetest.get_node_timer(pos):start(1.0)
	end,
	on_destruct = function(pos)
		minetest.get_node_timer(pos):stop()
	end,
	on_dig = function(pos, node, digger)
		return minetest.node_dig(pos, {name="relics:second_glass"}, digger)
	end
})

table.insert(relics, {
	itemstring = "relics:second_glass",
	ceil = -1000,
	floor = -2000
})
