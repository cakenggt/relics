local max_health = 100

minetest.register_node("relics:glass_heart", {
	description = "Glass Heart",
	drawtype = "nodebox",
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, 0.5, -0.375, -0.3125, 0.4375, -0.3125},-- top vein
			{-0.3125, 0.5, -0.3125, -0.25, 0.4375, -0.25},-- top vein
			{-0.4375, 0.4375, -0.4375, 0, -0.125, 0},-- main body
			{-0.25, 0.1875, -0.25, 0.125, -0.1875, 0.125},-- lower body
		}
	},
	use_texture_alpha = true,
	tiles = {
		{name = "relics_glass_heart.png", backface_culling = false}
	},
	groups = {oddly_breakable_by_hand = 3},
	drop = "",
	after_place_node = function(pos, placer, itemstack)
		local health = itemstack:get_meta():get_int("health")
		if health == nil then
			health = 0
		end
		minetest.get_meta(pos):set_int("health", health)
	end,
	after_dig_node = function(pos, oldnode, oldmetadata, digger)
		local health = oldmetadata.fields.health -- health will be a string
		if health == nil then
			health = 0
		else
			health = tonumber(health)
		end
		minetest.remove_node(pos)
		local inv = digger:get_inventory()
		local itemstack = ItemStack("relics:glass_heart")
		update_health(itemstack, health)
		if inv:room_for_item("main", itemstack) then
			inv:add_item("main", itemstack)
		else
			minetest.add_item(pos, itemstack)
		end
	end
})

function update_health(itemstack, health)
	if health <= max_health and health >= 0 then
		local item_meta = itemstack:get_meta()
		item_meta:set_int("health", health)
		item_meta:set_string("description", "Glass Heart ("..health.."/"..max_health..")")
	end
end

minetest.register_on_player_hpchange(function(player, hp_change)
	if hp_change > 0 then
		return hp_change
	end
	local inv = player:get_inventory()
	for i, item in ipairs(inv:get_list("main")) do
		if item:get_name() == "relics:glass_heart" then
			local stored_health = item:get_meta():get_int("health")
			if hp_change >= stored_health * -1 then
				-- it can remove the entire damage
				update_health(item, stored_health+hp_change)
				inv:set_stack("main", i, item)
				return 0
			else
				-- it can remove some of the damage
				hp_change = hp_change + stored_health
				update_health(item, 0)
				inv:set_stack("main", i, item)
			end
		end
	end
	-- now try to increase health in a glass heart
	local heart_pos = minetest.find_node_near(player:get_pos(), 10, {"relics:glass_heart"}, true)
	if heart_pos ~= nil then
		local heart_meta = minetest.get_meta(heart_pos)
		heart_meta:set_int("health", heart_meta:get_int("health") + (hp_change * -1))
		local distance = vector.distance(player:get_pos(), heart_pos)
		relics_helper.particle_travel(player:get_pos(), heart_pos, "relics_glass_heart_particle.png", 0, distance)
	end
	return hp_change
end, true)

table.insert(relics, {
	itemstring = "relics:glass_heart",
	ceil = -1000,
	floor = -2000
})
