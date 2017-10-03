minetest.register_node("relics:portable_hole", {
	description = "Portable Hole",
	drawtype = "signlike",
	tiles = {"relics_portable_hole_node.png"},
	inventory_image = "relics_portable_hole_item.png",
	wield_image = "relics_portable_hole_item.png",
	use_texture_alpha = true,
	paramtype = "light",
	paramtype2 = "wallmounted",
	selection_box = {
		type = "wallmounted"
	},
	walkable = false,
	groups = {oddly_breakable_by_hand = 3},
	after_place_node = function(pos, placer, itemstack, pointed_thing)
		local vec = minetest.wallmounted_to_dir(minetest.get_node(pos).param2)
		local node_meta = minetest.get_meta(pos)
		local phased = {}
		for i=1, 10, 1 do
			local new_loc = {x = pos.x+(vec.x*i), y = pos.y+(vec.y*i), z = pos.z+(vec.z*i)}
			phase_node(new_loc)
			table.insert(phased, new_loc)
		end
		node_meta:set_string("phased", minetest.serialize(phased))
		return false
	end,
	on_destruct = function(pos)
		local phased = minetest.deserialize(minetest.get_meta(pos):get_string("phased"))
		for i, node in ipairs(phased) do
			unphase_node(node)
		end
	end
})

function phase_node(pos)
	local prev_node = minetest.get_node(pos)
	minetest.swap_node(pos, {name = "relics:phased_node"})
	local node_meta = minetest.get_meta(pos)
	local prev_meta_table = node_meta:to_table()
	local node_timer = minetest.get_node_timer(pos)
	local prev_timeout = node_timer:get_timeout()
	local prev_elapsed = node_timer:get_elapsed()
	node_meta:from_table({
		fields = {
			relic_prev_node = minetest.serialize(prev_node),
			relic_prev_meta = minetest.serialize(prev_meta_table),
			relic_prev_timeout = prev_timeout,
			relic_prev_elapsed = prev_elapsed
		}
	})
end

function unphase_node(pos)
	if minetest.get_node(pos).name ~= "relics:phased_node" then
		return
	end
	local node_meta = minetest.get_meta(pos)
	local node_meta_table = node_meta:to_table()
	if node_meta_table.fields.relic_prev_node == nil then
		minetest.remove_node(pos)
		return false
	end
	minetest.swap_node(pos, minetest.deserialize(node_meta_table.fields.relic_prev_node))
	node_meta:from_table(minetest.deserialize(node_meta_table.fields.relic_prev_meta))
	-- reset any previous timer
	local node_timer = minetest.get_node_timer(pos)
	node_timer:set(node_meta_table.fields.relic_prev_timeout, node_meta_table.fields.relic_prev_elapsed)
end

minetest.register_node("relics:phased_node", {
	drawtype = "glasslike",
	tiles = {"relics_phased_node.png"},
	use_texture_alpha = true,
	post_effect_color = {a = 170, r = 0, g = 0, b = 0},
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = false,
	climbable = true,
	drop = "",
	groups = {not_in_creative_inventory = 1}
})

table.insert(relics, {
	itemstring = "relics:portable_hole",
	ceil = 0,
	floor = -50
})
