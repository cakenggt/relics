local repair_amount = 65535/3

minetest.register_craftitem("relics:repair_paste", {
	description = "Repair Paste",
	inventory_image = "relics_repair_paste.png",
	wield_image = "relics_repair_paste.png",
	on_use = minetest.item_eat(3)
})

function validate_repair(old_craft_grid)
	local paste
	local paste_index
	local tool
	local tool_index
	for i = 1, #old_craft_grid do
		if old_craft_grid[i]:get_name() == "relics:repair_paste" then
			if seed ~= nil then
				-- error
				return nil
			end
			paste = old_craft_grid[i]
			paste_index = i
		elseif old_craft_grid[i]:get_name() ~= "" then
			if copy ~= nil then
				-- error
				return nil
			end
			tool = old_craft_grid[i]
			tool_index = i
		end
	end
	if paste ~= nil and tool ~= nil then
		local result = ItemStack({name=tool:get_name(), count=1})
		local new_wear = tool:get_wear() - repair_amount
		if (new_wear > 0) then
			result:set_wear(new_wear)
		end
		return {
			paste=paste,
			paste_index=paste_index,
			tool=tool,
			tool_index=tool_index,
			result=result
		}
	else
		return nil
	end
end

minetest.register_craft_predict(function(itemstack, player, old_craft_grid, craft_inv)
	local validate_result = validate_repair(old_craft_grid)
	if validate_result ~= nil then
		return validate_result.result
	end
	return nil
end)

minetest.register_on_craft(function(itemstack, player, old_craft_grid, craft_inv)
	local validate_result = validate_repair(old_craft_grid)
	if validate_result ~= nil then
		validate_result.paste:take_item()
		validate_result.tool:take_item()
		-- put back any leftover items
		craft_inv:set_stack("craft", validate_result.tool_index, validate_result.tool)
		craft_inv:set_stack("craft", validate_result.paste_index, validate_result.paste)
		return validate_result.result
	end
	return nil
end)

table.insert(relics, {
	itemstring = "relics:repair_paste 32",
	ceil = 0,
	floor = -1000
})
