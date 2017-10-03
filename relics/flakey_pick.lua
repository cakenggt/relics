function after_use(itemstack, user, node, digparams)
	local uses = 270
	local wear = itemstack:get_wear()
	-- find out what pick it should be
	local new_name = "relics:flakey_pick_"..(math.floor(wear/6554))
	if new_name ~= itemstack:get_name() then
		itemstack:set_name(new_name)
	end
	itemstack:add_wear(digparams.wear)
	return itemstack
end

for i=0, 9, 1 do
	local groups = {}
	if i > 0 then
		groups.not_in_creative_inventory = 1
	end
	local times = {[3]=1.6-(i*0.2)}
	if i > 2 then
		times[2] = 2-(i/5)
	end
	if i > 5 then
		times[1] = 4-(i/3)
	end
	minetest.register_tool("relics:flakey_pick_"..i, {
		description = "Flakey Pick",
		inventory_image = "relics_flakey_pick.png",
		wield_image = "relics_flakey_pick.png",
		after_use = after_use,
		groups = groups,
		tool_capabilities = {
			full_punch_interval = 1.2-(0.06*i),
			max_drop_level=math.floor(i/2),
			groupcaps={
				cracky = {times=times, uses=30, maxlevel=1+math.floor(i/2)},
			},
			damage_groups = {fleshy=2+math.floor(i/2)}
		},
		sound = {breaks = "default_tool_breaks"}
	})
end

table.insert(relics, {
	itemstring = "relics:flakey_pick_0",
	ceil = -500,
	floor = -1000
})
