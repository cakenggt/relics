minetest.register_craftitem("relics:universal_solvent_container", {
	description = "Container of Universal Solvent",
	inventory_image = "relics_universal_solvent_container.png",
	wield_image = "relics_universal_solvent_container.png",
	on_place = function(itemstack, user, pointed_thing)
		if pointed_thing.type ~= "node" then
			return
		end
		minetest.set_node(pointed_thing.above, {name = "relics:universal_solvent_source"})
		local item_count = user:get_wielded_item():get_count()
		if item_count > 1 then
			local inv = user:get_inventory()
			if inv:room_for_item("main", {name = "relics:universal_solvent_container_empty"}) then
				inv:add_item("main", "relics:universal_solvent_container_empty")
			else
				local pos = user:getpos()
				pos.y = math.floor(pos.y + 0.5)
				minetest.add_item(pos, "relics:universal_solvent_container_empty")
			end
			itemstack:take_item()
			return itemstack
		else
			return ItemStack("relics:universal_solvent_container_empty")
		end
	end
})

-- register empty container
minetest.register_craftitem("relics:universal_solvent_container_empty", {
	description = "Empty Container of Universal Solvent",
	inventory_image = "relics_universal_solvent_container_empty.png",
	wield_image = "relics_universal_solvent_container_empty.png",
	liquids_pointable = true,
	on_use = function(itemstack, user, pointed_thing)
		if pointed_thing.type ~= "node" then
			return
		end
		local node = minetest.get_node(pointed_thing.under)
		if node.name == "relics:universal_solvent_source" then
			minetest.remove_node(pointed_thing.under)
			local item_count = user:get_wielded_item():get_count()
			if item_count > 1 then
				local inv = user:get_inventory()
				if inv:room_for_item("main", {name = "relics:universal_solvent_container"}) then
					inv:add_item("main", "relics:universal_solvent_container")
				else
					local pos = user:getpos()
					pos.y = math.floor(pos.y + 0.5)
					minetest.add_item(pos, "relics:universal_solvent_container")
				end
				itemstack:take_item()
				return itemstack
			else
				return ItemStack("relics:universal_solvent_container")
			end
		end
	end
})

-- register liquid flowing and source
minetest.register_node("relics:universal_solvent_source", {
	description = "Universal Solvent",
	drawtype = "liquid",
	tiles = {"relics_universal_solvent_source.png"},
	alpha = 160,
	paramtype = "light",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	drowning = 1,
	liquidtype = "source",
	liquid_alternative_flowing = "relics:universal_solvent_flowing",
	liquid_alternative_source = "relics:universal_solvent_source",
	liquid_viscosity = 1,
	damage_per_second = 8,
	post_effect_color = {a = 103, r = 30, g = 60, b = 90},
	groups = {water = 3, liquid = 3, puts_out_fire = 1, cools_lava = 1},
	sounds = default.node_sound_water_defaults(),
})

minetest.register_node("relics:universal_solvent_flowing", {
	description = "Flowing Universal Solvent",
	drawtype = "flowingliquid",
	tiles = {"relics_universal_solvent_flowing.png"},
	special_tiles = {
		{
			name = "relics_universal_solvent_flowing.png",
			backface_culling = true
		},
		{
			name = "relics_universal_solvent_flowing.png",
			backface_culling = false
		}
	},
	alpha = 160,
	paramtype = "light",
	paramtype2 = "flowingliquid",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	drowning = 1,
	liquidtype = "flowing",
	liquid_alternative_flowing = "relics:universal_solvent_flowing",
	liquid_alternative_source = "relics:universal_solvent_source",
	liquid_viscosity = 1,
	damage_per_second = 8,
	post_effect_color = {a = 103, r = 30, g = 60, b = 90},
	groups = {water = 3, liquid = 3, puts_out_fire = 1,
		not_in_creative_inventory = 1, cools_lava = 1},
	sounds = default.node_sound_water_defaults(),
})

minetest.register_abm({
	label = "universal solvent eating",
	nodenames = {"group:crumbly", "group:cracky", "group:snappy", "group:choppy"},
	neighbors = {"relics:universal_solvent_source", "relics:universal_solvent_flowing"},
	interval = 2,
	chance = 5,
	action = function(pos, node, active_object_count, active_object_count_wider)
		minetest.transforming_liquid_add(pos)
		minetest.remove_node(pos)
	end
})

table.insert(relics, {
	itemstring = "relics:universal_solvent_container",
	ceil = -3000
})
