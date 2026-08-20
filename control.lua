-- Control.lua - Coffres Réseau Linked Chest 2.x

local mod_gui = require("__core__/lualib/mod-gui")

local gui_frame = "dim_chest_gui"
local gui_dropdown = "dim_chest_dropdown"
local gui_button_create = "dim_chest_create"
local gui_button_edit = "dim_chest_edit"
local gui_button_delete = "dim_chest_delete"
local gui_button_apply = "dim_chest_apply"
local gui_button_unlink = "dim_chest_unlink"
local gui_button_ok = "dim_chest_ok"
local gui_button_cancel = "dim_chest_cancel"
local gui_textfield = "dim_chest_text"

local mod_gui_flow_name = "dim_chest_network_flow"

-- initialisation storage.coffres si nécessaire
storage.coffres = storage.coffres or {}

local chest_types = {
    ["coffre-dimensionnel"] = {number=1, display={"", {"dim-coffre-dimensionnel"}}, size = 16},
    ["grand-coffre-dimensionnel"] = {number=2, display={"", {"dim-grand-coffre-dimensionnel"}}, size = 32},
    ["container-dimensionnel"] = {number=3, display={"", {"dim-container-dimensionnel"}}, size = 64},
    ["grand-container-dimensionnel"] = {number=4, display={"", {"dim-grand-container-dimensionnel"}}, size = 128},
    ["entrepot-dimensionnel"] = {number=5, display={"", {"dim-entrepot-dimensionnel"}}, size = 256},
    ["grand-entrepot-dimensionnel"] = {number=6, display={"", {"dim-grand-entrepot-dimensionnel"}}, size = 512}
}

-- Nom du prototype "animation" (défini dans chests.lua) à jouer pour chaque type de coffre
local chest_animation_names = {
    ["coffre-dimensionnel"] = "coffre-dimensionnel-animation",
    ["grand-coffre-dimensionnel"] = "grand-coffre-dimensionnel-animation",
    ["container-dimensionnel"] = "container-dimensionnel-animation",
    ["grand-container-dimensionnel"] = "grand-container-dimensionnel-animation",
    ["entrepot-dimensionnel"] = "entrepot-dimensionnel-animation",
    ["grand-entrepot-dimensionnel"] = "grand-entrepot-dimensionnel-animation"
}

-- table des objets de rendu actifs (unit_number -> LuaRenderObject)
storage.render_objects = storage.render_objects or {}

-- démarre l'animation de liaison sur un coffre (ne fait rien si déjà active)
local function start_chest_animation(chest)
    if not (chest and chest.valid) then return end
    local existing = storage.render_objects[chest.unit_number]
    if existing and existing.valid then return end

    local anim_name = chest_animation_names[chest.name]
    if not anim_name then return end

    storage.render_objects[chest.unit_number] = rendering.draw_animation{
        animation = anim_name,
        target = chest,
        surface = chest.surface,
        render_layer = "object"
    }
end

-- arrête (détruit) l'animation de liaison d'un coffre
local function stop_chest_animation(unit_number)
    local existing = storage.render_objects[unit_number]
    if existing and existing.valid then
        existing.destroy()
    end
    storage.render_objects[unit_number] = nil
end

-- synchronise l'animation avec l'état de liaison réel du coffre
local function update_chest_animation(chest)
    if not (chest and chest.valid) then return end
    if chest.link_id and chest.link_id > 0 then
        start_chest_animation(chest)
    else
        stop_chest_animation(chest.unit_number)
    end
end

-- reconstruit les animations manquantes (après chargement/mise à jour du mod)
-- on se base sur chest.link_id (état natif réel du coffre), pas sur la valeur
-- potentiellement obsolète stockée dans storage.coffres
local function resync_all_chest_animations()
    for unit_number, info in pairs(storage.coffres or {}) do
        local surface = game.surfaces[info.surface]
        local chest = surface and surface.find_entity(info.name, info.position)
        if chest and chest.valid and chest.unit_number == unit_number then
            update_chest_animation(chest)
        end
    end
end

script.on_init(resync_all_chest_animations)
script.on_configuration_changed(resync_all_chest_animations)

-- récupérer réseaux depuis storage
local function get_networks(chest_type)
    storage.networks = storage.networks or {}
    storage.networks[chest_type] = storage.networks[chest_type] or {}
    return storage.networks[chest_type]
end

-- sauvegarder réseaux dans storage
local function save_networks(chest_type, nets)
    storage.networks[chest_type] = nets
end

-- helpers
local function close_frame(player, name)
    local f = player.gui.screen[name]
    if f then f.destroy() end
end

-- liste réseau
local function find_dropdown(root)
    if not root or not root.valid then return nil end
    if root.name == gui_dropdown then return root end
    if root.children then
        for _, child in pairs(root.children) do
            local found = find_dropdown(child)
            if found then return found end
        end
    end
    return nil
end

-- mettre a jour liste réseau
local function refresh_dropdown(player, chest_type)
    local f = player.gui.screen[gui_frame]
    if not f or not f.valid then return end
    local dd = find_dropdown(f)
    if not dd then return end
    dd.clear_items()
    local nets = get_networks(chest_type)
    for _, net in pairs(nets) do
        dd.add_item(tostring(net.id) .. " - " .. net.name)
    end
end

-- créer un réseau
local function create_network(name, chest_type)
    local nets = get_networks(chest_type)

    -- vérifier doublon
    for _, net in pairs(nets) do
        if net.name == name then
            game.print({"dim-name_network-exist"})
            return nil
        end
    end

    local next_id = 1
    for _, net in pairs(nets) do
        if net.id >= next_id then next_id = net.id + 1 end
    end
    table.insert(nets, {name=name, id=next_id, chests={}})
    save_networks(chest_type, nets)
    return next_id
end

-- supprimer un réseau
local function delete_network_by_id(id, chest_type)
    local nets = get_networks(chest_type)
    for net_index = #nets,1,-1 do
        local net = nets[net_index]
        if net.id == id then
            local linked_chests = {}
            for _, unit in pairs(net.chests) do
                local info = storage.coffres[unit]
                if info then
                    local surface = game.surfaces[info.surface]
                    if surface then
                        local ent = surface.find_entity(info.name, info.position)
                        if ent and ent.valid then
                            table.insert(linked_chests, {
                                name = ent.name,
                                surface = surface.name,
                                position = ent.position
                            })
                        end
                    end
                end
            end

            if #linked_chests > 0 then
                game.print({"dim-network-allways-connected", net.name, net.id})
                for _, c in pairs(linked_chests) do
                    game.print(c.name.." / "..c.surface.." / x: "..c.position.x.." / y: "..c.position.y)
                end
                return
            else
                table.remove(nets, net_index)
                save_networks(chest_type, nets)
                return
            end
        end
    end
end

-- ajouter coffre lié a un réseau
local function add_chest_to_network(chest, id)
    local chest_type = chest.name
    chest.link_id = id

    -- stocker ou mettre à jour les caractéristiques dans storage
    storage.coffres[chest.unit_number] = {
        name = chest.name,
        surface = chest.surface.name,
        position = chest.position,
        link_id = id
    }

    local nets = get_networks(chest_type)
    for _, net in pairs(nets) do
        if net.id == id then
            table.insert(net.chests, chest.unit_number)
            save_networks(chest_type, nets)
            update_chest_animation(chest)
            return
        end
    end
end

-- GUI réseau
local function show_network_gui(player, chest)
    close_frame(player, gui_frame)
    local f = player.gui.screen.add{
        type = "frame",
        name = gui_frame,
        caption = (chest_types[chest.name] and chest_types[chest.name].display or chest.name),
        direction = "vertical"
    }
    f.tags = { chest_unit_number = chest.unit_number, chest_name = chest.name }

    -- top flow
    local top_flow = f.add{ type="flow", direction="vertical" }
    local chest_info = chest_types[chest.name] or { display = chest.name }
	local sel = chest.link_id
	local sel2 = 0
	if sel and sel > 0 then
		for _, net in pairs(get_networks(chest.name)) do
			if net.id == sel then
				sel2 = net.name
				break
			end
		end
	end
	if sel2 == 0 then
		top_flow.add{type="label", caption = {"dim-network-selected-caption2", sel}}
	else
		top_flow.add{type="label", caption = {"dim-network-selected-caption", sel, sel2}}
	end
	

	-- flow vertical pour dropdown + boutons
	local flow2 = top_flow.add{ type="flow", direction="vertical" }
	flow2.add{ type="drop-down", name = gui_dropdown }

	-- flow horizontal pour les boutons
	local button_flow = flow2.add{ type="flow", direction="horizontal" }
	button_flow.add{
		type="sprite-button",
		name = gui_button_apply,
		sprite = "utility/check_mark_green",
		tooltip = {"dim-apply"},
		style = "slot_button"
	}
	button_flow.add{
		type="sprite-button",
		name = gui_button_edit,
		sprite = "utility/rename_icon",
		tooltip = {"dim-edit-network"},
		style = "slot_button"
	}
	button_flow.add{
		type="sprite-button",
		name = gui_button_delete,
		sprite = "utility/trash",
		tooltip = {"dim-delete-network"},
		style = "slot_button"
	}

	-- bottom flow
	local bottom_flow = f.add{ type="flow", direction="vertical" }
	bottom_flow.add{ type="button", name = gui_button_unlink, caption = {"dim-unlink"} }
	bottom_flow.add{ type="button", name = gui_button_create, caption = {"dim-create"} }

    refresh_dropdown(player, chest.name)

    -- position fixe
    local screen_width = player.display_resolution.width
    local screen_height = player.display_resolution.height
    f.location = { x = screen_width * 0.8, y = screen_height * 0.50 }
end

-- GUI click
script.on_event(defines.events.on_gui_click, function(e)
    local player = game.get_player(e.player_index)
    local element = e.element
    if not element or not element.valid then return end
    local f = player.gui.screen[gui_frame]

    -- create réseau
    if element.name == gui_button_create and f and f.valid then
        close_frame(player, gui_button_ok)
        local dialog = player.gui.screen.add{
			type="frame",
			name=gui_button_ok,
			caption={"dim-create-network"},
			direction="vertical"
		}
        dialog.add{ type="textfield", name=gui_textfield }
        local flow = dialog.add{ type="flow", direction="horizontal" }
        flow.add{ type="button", name=gui_button_ok, caption={"dim-ok"} }
        flow.add{ type="button", name=gui_button_cancel, caption={"dim-cancel"} }
        dialog.tags = { chest_name = f.tags.chest_name, chest_unit_number = f.tags.chest_unit_number }
        dialog.force_auto_center()
        return
    end

    -- delete réseau
    if element.name == gui_button_delete and f and f.valid then
        local dd = find_dropdown(f)
        if dd and dd.selected_index > 0 then
            local sel_text = dd.get_item(dd.selected_index)
            local id = tonumber(sel_text:match("^(%d+)"))
            if id then
                delete_network_by_id(id, f.tags.chest_name)
                refresh_dropdown(player, f.tags.chest_name)
            end
        end
        return
    end
	
		-- edit réseau
	if element.name == gui_button_edit and f and f.valid then
		local dd = find_dropdown(f)
		if dd and dd.selected_index > 0 then
			local sel_text = dd.get_item(dd.selected_index)
			local id = tonumber(sel_text:match("^(%d+)"))
			if id then
				local nets = get_networks(f.tags.chest_name)
				local target_net
				for _, net in pairs(nets) do
					if net.id == id then
						target_net = net
						break
					end
				end
				if target_net then
					close_frame(player, gui_button_ok)
					local dialog = player.gui.screen.add{
						type="frame",
						name=gui_button_ok,
						caption={"dim-edit-network"},
						direction="vertical"
					}
					dialog.add{
						type="textfield",
						name=gui_textfield,
						text=target_net.name
					}
					local flow = dialog.add{ type="flow", direction="horizontal" }
					flow.add{ type="button", name=gui_button_ok, caption={"dim-ok"} }
					flow.add{ type="button", name=gui_button_cancel, caption={"dim-cancel"} }
					dialog.tags = {
						chest_name = f.tags.chest_name,
						chest_unit_number = f.tags.chest_unit_number,
						network_id = id
					}
					dialog.force_auto_center()
				end
			end
		end
		return
	end


	-- apply réseau
	if element.name == gui_button_apply and f and f.valid then
		local dd = find_dropdown(f)
		if dd and dd.selected_index > 0 then
			local sel_text = dd.get_item(dd.selected_index)
			local id = tonumber(sel_text:match("^(%d+)"))
			local chest = player.opened
			if chest and chest.valid and id then
				add_chest_to_network(chest, id)
				game.print({"dim-network-applied", sel_text})
				show_network_gui(player, chest)
			end
		end
		return
	end

	-- unlink
	if element.name == gui_button_unlink and f and f.valid then
		local chest = player.opened
		if chest and chest.valid then
			if chest.link_id == 0 then
				game.print({"dim-chest-not-linked"})
			else
				chest.link_id = 0
				local chest_type = chest.name
				for _, net in pairs(get_networks(chest_type)) do
					for i=#net.chests,1,-1 do
						if net.chests[i] == chest.unit_number then
							table.remove(net.chests, i)
						end
					end
				end
				stop_chest_animation(chest.unit_number)
				game.print({"dim-chest-unlinked"})
			end
			show_network_gui(player, chest)
		end
		return
	end

	-- OK (création / édition)
	if element.name == gui_button_ok and f and f.valid then
		local dialog = player.gui.screen[gui_button_ok]
		if not dialog then return end
		local text = dialog[gui_textfield].text:match("^%s*(.-)%s*$") or ""
		if text ~= "" then
			if dialog.tags.network_id then
				-- édition
				local id = dialog.tags.network_id
				local nets = get_networks(f.tags.chest_name)
				for _, net in pairs(nets) do
					if net.id == id then
						net.name = text
						save_networks(f.tags.chest_name, nets)
						game.print({"dim-network-edited", text, id})
						break
					end
				end
			else
				-- création
				local id = create_network(text, f.tags.chest_name)
				if id then
					game.print({"dim-network-created", text, id})
				else
					game.print({"dim-network-create-failed"})
				end
			end
			local chest = player.opened
			if chest and chest.valid then
				show_network_gui(player, chest)
			end
		end
		close_frame(player, gui_button_ok)
		return
	end


    -- cancel
    if element.name == gui_button_cancel then
        close_frame(player, gui_button_ok)
        return
    end
end)

-- Copier/coller les paramètres d'un coffre dimensionnel
local function copy_paste_chest_settings(event)
    local player_index = event.player_index
    if not (player_index and game.players[player_index] and game.players[player_index].connected) then return end
    if not (event.source and event.source.valid and event.destination and event.destination.valid) then return end

    -- Vérifier que ce sont des coffres dimensionnels
    local valid_names = {
        ["coffre-dimensionnel"] = true,
        ["grand-coffre-dimensionnel"] = true,
        ["container-dimensionnel"] = true,
        ["grand-container-dimensionnel"] = true,
        ["entrepot-dimensionnel"] = true,
        ["grand-entrepot-dimensionnel"] = true
    }
    if not (valid_names[event.source.name] and valid_names[event.destination.name]) then return end

    local source_info = storage.coffres[event.source.unit_number]
	if source_info then
		-- Copier les caractéristiques et position
		storage.coffres[event.destination.unit_number] = {
			name = event.destination.name,
			surface = event.destination.surface.name,
			position = event.destination.position,
			link_id = source_info.link_id or 0,
			channel = source_info.channel,
			autres_parametres = source_info.autres_parametres
		}
		-- ajouter au réseau si link_id > 0
		if source_info.link_id and source_info.link_id > 0 then
			local nets = get_networks(event.destination.name)
			for _, net in pairs(nets) do
				if net.id == source_info.link_id then
					event.destination.link_id = source_info.link_id  -- appliquer le réseau
					table.insert(net.chests, event.destination.unit_number)
					save_networks(event.destination.name, nets)
					break
				end
			end
		end

		update_chest_animation(event.destination)
	end
end

-- Détection placement par joueur ou robot
local function on_chest_built(event)
    local entity = event.created_entity or event.entity
    if not (entity and chest_types[entity.name]) then return end

    -- tenter de récupérer les paramètres copiés depuis le coffre source
    local source_data = nil
    if event.stack and event.stack.valid_for_read and event.stack.is_blueprint then
        -- blueprint : vérifier s'il y a un tag de stockage de paramètres
        local tags = event.stack.get_blueprint_entities() or {}
        for _, e in pairs(tags) do
            if e.name and storage.coffres[e.unit_number] then
                source_data = storage.coffres[e.unit_number]
                break
            end
        end
    end

    -- si pas de source blueprint, vérifier storage classique
    if not source_data and storage.coffres[entity.unit_number] then
        source_data = storage.coffres[entity.unit_number]
    end

    local link_id = (source_data and source_data.link_id) or entity.link_id or 0

    -- stocker ou mettre à jour les caractéristiques
    storage.coffres[entity.unit_number] = {
        name = entity.name,
        surface = entity.surface.name,
        position = entity.position,
        link_id = link_id,
        channel = source_data and source_data.channel,
        autres_parametres = source_data and source_data.autres_parametres
    }

    -- ajouter au réseau si link_id > 0
    if link_id > 0 then
        local nets = get_networks(entity.name)
        for _, net in pairs(nets) do
            if net.id == link_id then
                table.insert(net.chests, entity.unit_number)
                save_networks(entity.name, nets)
                break
            end
        end
    end

    entity.link_id = link_id
    update_chest_animation(entity)
end

-- Détection suppression par joueur ou robot
local function on_chest_removed(event)
    local entity = event.entity
    if entity and chest_types[entity.name] then
        -- Supprimer du storage
        storage.coffres[entity.unit_number] = nil

        -- Supprimer de tout réseau lié
        for chest_type, nets in pairs(storage.networks or {}) do
            for _, net in pairs(nets) do
                for i=#net.chests,1,-1 do
                    if net.chests[i] == entity.unit_number then
                        table.remove(net.chests, i)
                    end
                end
            end
        end

        stop_chest_animation(entity.unit_number)
    end
end

-- ouverture GUI coffre
script.on_event(defines.events.on_gui_opened, function(e)
    if e.entity and chest_types[e.entity.name] then
        local player = game.get_player(e.player_index)
        show_network_gui(player, e.entity)
    end
end)

-- fermeture GUI
script.on_event(defines.events.on_gui_closed, function(e)
    if e.entity and chest_types[e.entity.name] then
        local player = game.get_player(e.player_index)
        close_frame(player, gui_frame)
		close_frame(player, gui_button_ok)
        local flow = player.gui.screen[mod_gui_flow_name]
        if flow and flow.valid then
            flow.destroy()
        end
    end
end)

-- gestion copie/coller paramètres
script.on_event(defines.events.on_entity_settings_pasted, function(e)
    local src = e.source
    local dst = e.destination
    if not (src.valid and dst.valid) then return end
    local valid_names = {
        ["coffre-dimensionnel"]=true,
        ["grand-coffre-dimensionnel"]=true,
        ["container-dimensionnel"]=true,
        ["grand-container-dimensionnel"]=true,
        ["entrepot-dimensionnel"]=true,
        ["grand-entrepot-dimensionnel"]=true
    }
    if not (valid_names[src.name] and valid_names[dst.name]) then return end

    local src_info = storage.coffres[src.unit_number]
    if not src_info then return end

    -- copier les paramètres
    storage.coffres[dst.unit_number] = {
        name = dst.name,
        surface = dst.surface.name,
        position = dst.position,
        link_id = src_info.link_id or 0,
        channel = src_info.channel,
        autres_parametres = src_info.autres_parametres
    }

    dst.link_id = src_info.link_id or 0

    -- ajouter au réseau si link_id > 0
    if src_info.link_id and src_info.link_id > 0 then
        local nets = get_networks(dst.name)
        for _, net in pairs(nets) do
            if net.id == src_info.link_id then
                table.insert(net.chests, dst.unit_number)
                save_networks(dst.name, nets)
                break
            end
        end
    end

    update_chest_animation(dst)
end)

-- Inscription des events
script.on_event(defines.events.on_built_entity, on_chest_built)
script.on_event(defines.events.on_robot_built_entity, on_chest_built)
script.on_event(defines.events.script_raised_built, on_chest_built)
script.on_event(defines.events.on_player_mined_entity, on_chest_removed)
script.on_event(defines.events.on_robot_mined_entity, on_chest_removed)
script.on_event(defines.events.on_entity_died, on_chest_removed)
script.on_event(defines.events.script_raised_destroy, on_chest_removed)
script.on_event(defines.events.on_entity_settings_pasted, copy_paste_chest_settings)
