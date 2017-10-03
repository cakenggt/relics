minetest.register_craftitem("relics:watch", {
	description = "Watch Relic",
	inventory_image = "relics_watch.png",
	wield_image = "relics_watch.png",
	on_use = function(itemstack, user, pointed_thing)
		local boolean, log_messages = minetest.rollback_revert_actions_by("player:"..user:get_player_name(), 10)
		minetest.chat_send_all(minetest.serialize(log_messages))
		itemstack:take_item()
		return itemstack
	end
})

table.insert(relics, {
	itemstring = "relics:watch",
	ceil = nil,
	floor = -50
})
