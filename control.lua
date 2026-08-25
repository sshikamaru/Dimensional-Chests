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
local gui_search_field = "dim_chest_search"

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
    ["grand-entrepot-dimensionnel"] = "grand-entrepot-dimensionnel-animation",
    ["reservoir-dimensionnel"] = "reservoir-dimensionnel-animation"
}

-- Réservoirs dimensionnels (fluides). Contrairement aux coffres (linked-container,
-- fusion d'inventaire native), le storage-tank n'a pas de mise en réseau native :
-- on simule la fusion en synchronisant périodiquement le contenu des fluidbox
-- de tous les réservoirs d'un même réseau (voir sync_fluid_networks plus bas).
local tank_types = {
    ["reservoir-dimensionnel"] = {number=1, display={"", {"dim-reservoir-dimensionnel"}}, capacity = 200000}
}

-- initialisation storage.reservoirs si nécessaire (équivalent de storage.coffres pour les fluides)
storage.reservoirs = storage.reservoirs or {}

-- Fréquence (en ticks) de synchronisation des réseaux de fluides. Plus bas =
-- plus réactif mais plus coûteux en performance. 30 ticks = 2 fois/seconde.
local FLUID_SYNC_INTERVAL = 30

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

-- synchronise l'animation avec l'état de liaison réel du coffre ou du réservoir
-- NB : la propriété .link_id n'existe que sur les linked-container (coffres) ;
-- pour les réservoirs (storage-tank), l'état de liaison vient de storage.reservoirs
local function update_chest_animation(chest)
    if not (chest and chest.valid) then return end
    storage.reservoirs = storage.reservoirs or {}
    local link_id = 0
    if chest_types[chest.name] then
        link_id = chest.link_id or 0
    elseif tank_types[chest.name] then
        local info = storage.reservoirs[chest.unit_number]
        link_id = (info and info.link_id) or 0
    end
    if link_id > 0 then
        start_chest_animation(chest)
    else
        stop_chest_animation(chest.unit_number)
    end
end

-- reconstruit les animations manquantes (après chargement/mise à jour du mod)
-- on se base sur l'état de liaison réel (pas sur une valeur potentiellement
-- obsolète stockée dans storage), pour les coffres comme pour les réservoirs
local function resync_all_chest_animations()
    for unit_number, info in pairs(storage.coffres or {}) do
        local surface = game.surfaces[info.surface]
        local chest = surface and surface.find_entity(info.name, info.position)
        if chest and chest.valid and chest.unit_number == unit_number then
            update_chest_animation(chest)
        end
    end
    for unit_number, info in pairs(storage.reservoirs or {}) do
        local surface = game.surfaces[info.surface]
        local tank = surface and surface.find_entity(info.name, info.position)
        if tank and tank.valid and tank.unit_number == unit_number then
            update_chest_animation(tank)
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

-- récupère les infos stockées d'une entité (coffre objet OU réservoir fluide)
-- à partir de son unit_number, peu importe dans laquelle des deux tables elle vit
local function get_stored_info(unit_number)
    storage.coffres = storage.coffres or {}
    storage.reservoirs = storage.reservoirs or {}
    return storage.coffres[unit_number] or storage.reservoirs[unit_number]
end

-- récupère l'id de réseau courant d'une entité, que ce soit un coffre
-- (link_id natif du linked-container) ou un réservoir (link_id maison, car
-- storage-tank n'a pas de link_id natif)
local function get_link_id(entity)
    if not (entity and entity.valid) then return 0 end
    if chest_types[entity.name] then
        return entity.link_id or 0
    elseif tank_types[entity.name] then
        storage.reservoirs = storage.reservoirs or {}
        local info = storage.reservoirs[entity.unit_number]
        return (info and info.link_id) or 0
    end
    return 0
end

-- helpers
local function close_frame(player, name)
    local f = player.gui.screen[name]
    if f then f.destroy() end
end

-- retrouve récursivement un élément GUI par son nom
local function find_by_name(root, name)
    if not root or not root.valid then return nil end
    if root.name == name then return root end
    if root.children then
        for _, child in pairs(root.children) do
            local found = find_by_name(child, name)
            if found then return found end
        end
    end
    return nil
end

local function find_dropdown(root)
    return find_by_name(root, gui_dropdown)
end

local function find_search_field(root)
    return find_by_name(root, gui_search_field)
end

-- mettre a jour liste réseau ; filter (optionnel) filtre par sous-chaîne
-- insensible à la casse sur le nom OU l'id du réseau
local function refresh_dropdown(player, chest_type, filter)
    local f = player.gui.screen[gui_frame]
    if not f or not f.valid then return end
    local dd = find_dropdown(f)
    if not dd then return end
    dd.clear_items()
    local nets = get_networks(chest_type)
    filter = filter and filter:match("^%s*(.-)%s*$") or ""
    local filter_lower = filter ~= "" and filter:lower() or nil
    for _, net in pairs(nets) do
        local item_text = tostring(net.id) .. " - " .. net.name
        if not filter_lower or item_text:lower():find(filter_lower, 1, true) then
            dd.add_item(item_text)
        end
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
                local info = get_stored_info(unit)
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

-- ajouter un réservoir à un réseau de fluide (équivalent add_chest_to_network pour les fluides)
local function add_tank_to_network(tank, id)
    storage.reservoirs = storage.reservoirs or {}
    local tank_type = tank.name

    storage.reservoirs[tank.unit_number] = {
        name = tank.name,
        surface = tank.surface.name,
        position = tank.position,
        link_id = id
    }

    local nets = get_networks(tank_type)
    for _, net in pairs(nets) do
        if net.id == id then
            net.pool = net.pool or {name = nil, amount = 0, temperature = nil}
            table.insert(net.chests, tank.unit_number)
            -- si le réseau contient déjà un fluide, verrouille immédiatement ce réservoir dessus
            if net.pool.name then
                tank.fluidbox.set_filter(1, {name = net.pool.name})
            end
            save_networks(tank_type, nets)
            update_chest_animation(tank)
            return
        end
    end
end

-- retirer un réservoir de son réseau de fluide (déliage), en reversant sa
-- dernière quantité connue au pool avant de le rendre indépendant
local function remove_tank_from_network(tank_or_unit_number, tank_type)
    storage.reservoirs = storage.reservoirs or {}
    local unit_number = type(tank_or_unit_number) == "number" and tank_or_unit_number or tank_or_unit_number.unit_number
    local nets = get_networks(tank_type)
    for _, net in pairs(nets) do
        for i = #net.chests, 1, -1 do
            if net.chests[i] == unit_number then
                table.remove(net.chests, i)
            end
        end
        -- réseau vidé de tout réservoir : on oublie le fluide mémorisé pour
        -- ne pas verrouiller le prochain réservoir qui le rejoindra sur un
        -- type de fluide périmé
        if #net.chests == 0 then
            net.pool = {name = nil, amount = 0, temperature = nil}
        end
    end
    save_networks(tank_type, nets)

    local tank = tank_or_unit_number
    if type(tank) == "number" then tank = nil end
    if tank and tank.valid then
        tank.fluidbox.set_filter(1, nil)
    end

    if storage.reservoirs[unit_number] then
        storage.reservoirs[unit_number].link_id = 0
        -- on garde la quantité actuelle comme référence pour le blocage
        -- d'insertion (sinon le réservoir se ferait immédiatement vider
        -- par enforce_unlinked_tanks_extract_only au prochain contrôle)
        local fb = tank and tank.valid and tank.fluidbox[1]
        storage.reservoirs[unit_number].last_amount = fb and fb.amount or 0
    end
end

-- synchronise périodiquement le contenu des fluidbox de tous les réservoirs
-- d'un même réseau : on additionne ce que contient chaque réservoir, puis on
-- redistribue le total à parts égales (comme une grande cuve virtuelle
-- partagée, façon ender tank). La physique normale des fluides (pompes,
-- tuyaux) continue de remplir/vider chaque réservoir individuellement entre
-- deux synchronisations.
local function sync_fluid_networks()
    storage.reservoirs = storage.reservoirs or {}
    for tank_type, _ in pairs(tank_types) do
        local nets = get_networks(tank_type)
        if #nets > 0 then
            local networks_changed = false
            for _, net in pairs(nets) do
                net.pool = net.pool or {name = nil, amount = 0, temperature = nil}

                if #net.chests > 0 then
                    -- 1) collecte : on résout chaque unit_number en entité valide,
                    -- on nettoie les entrées mortes au passage, et on additionne le
                    -- fluide RÉELLEMENT présent. IMPORTANT : fluid_name est dérivé
                    -- uniquement du contenu actuel des réservoirs, jamais de
                    -- l'ancien net.pool.name -- sinon un nom périmé (fluide d'un
                    -- réservoir qui a quitté le réseau) fait croire que tout
                    -- fluide différent est "en trop" et le fait effacer plus bas.
                    local valid_units = {}
                    local total = 0
                    local fluid_name = nil
                    local temperature = nil

                    for _, unit in pairs(net.chests) do
                        local info = storage.reservoirs[unit]
                        local surface = info and game.surfaces[info.surface]
                        local tank = surface and surface.find_entity(info.name, info.position)
                        if tank and tank.valid and tank.unit_number == unit then
                            table.insert(valid_units, unit)
                            local fb = tank.fluidbox[1]
                            if fb and fb.amount and fb.amount > 0.001 then
                                if not fluid_name then
                                    fluid_name = fb.name
                                    temperature = fb.temperature
                                end
                                if fb.name == fluid_name then
                                    total = total + fb.amount
                                end
                            end
                        end
                    end

                    if #valid_units ~= #net.chests then
                        net.chests = valid_units
                        networks_changed = true
                    end

                    net.pool.name = fluid_name
                    net.pool.temperature = temperature
                    net.pool.amount = total

                    -- 2) distribution : part égale par réservoir, plafonnée à sa
                    -- capacité. On ne touche QUE les réservoirs vides ou contenant
                    -- déjà fluid_name -- un réservoir avec un fluide différent
                    -- (cas rare, normalement empêché par le filtre) est laissé
                    -- intact plutôt qu'écrasé.
                    if fluid_name and #valid_units > 0 then
                        local capacity = (tank_types[tank_type] and tank_types[tank_type].capacity) or 25000
                        local share = math.min(total / #valid_units, capacity)

                        for _, unit in pairs(valid_units) do
                            local info = storage.reservoirs[unit]
                            local surface = info and game.surfaces[info.surface]
                            local tank = surface and surface.find_entity(info.name, info.position)
                            if tank and tank.valid then
                                local fb = tank.fluidbox[1]
                                if not fb or fb.name == fluid_name then
                                    if share > 0.001 then
                                        tank.fluidbox[1] = {name = fluid_name, amount = share, temperature = temperature}
                                    else
                                        tank.fluidbox[1] = nil
                                    end
                                    -- verrouille le fluidbox sur le fluide du réseau pour éviter tout mélange
                                    tank.fluidbox.set_filter(1, {name = fluid_name})
                                end
                            end
                        end
                    end
                end
            end
            if networks_changed then save_networks(tank_type, nets) end
        end
    end
end

script.on_nth_tick(FLUID_SYNC_INTERVAL, sync_fluid_networks)

-- Fréquence (en ticks) de contrôle des réservoirs NON liés. À 1, le contrôle
-- tourne chaque tick : c'est le minimum pour réduire au maximum la fenêtre
-- pendant laquelle un pompage externe reste visible avant d'être annulé.
local UNLINKED_TANK_CHECK_INTERVAL = 1

-- Un réservoir non lié à un réseau ne doit pouvoir QUE se vider (extraction
-- libre via pompe/tuyau), jamais se remplir depuis l'extérieur.
-- Le storage-tank ne supporte PAS de connexions à sens unique au niveau
-- prototype (testé : le moteur exige "direction" tout en le refusant dès que
-- flow_direction != "input-output" -- "Pipeline entities do not support
-- directional connections" / "Key direction not found", contradictoires).
-- On simule donc ce comportement en mémorisant la dernière quantité connue
-- et en annulant toute augmentation détectée entre deux contrôles.
-- CAVEAT : le fluide poussé depuis l'extérieur pendant la fenêtre entre deux
-- contrôles est réellement retiré de la source (pompe/tuyau) puis effacé ici
-- -- il n'est pas restitué. À 1 tick d'intervalle la perte reste minime
-- (quelques unités par insertion tentée, pas de duplication).
local function enforce_unlinked_tanks_extract_only()
    for unit_number, info in pairs(storage.reservoirs or {}) do
        if (info.link_id or 0) == 0 then
            local surface = game.surfaces[info.surface]
            local tank = surface and surface.find_entity(info.name, info.position)
            if tank and tank.valid and tank.unit_number == unit_number then
                local fb = tank.fluidbox[1]
                local current = fb and fb.amount or 0
                local last = info.last_amount or 0

                if current > last + 0.001 then
                    -- insertion externe détectée : refusée, retour à la dernière quantité connue
                    if last > 0.001 and fb then
                        tank.fluidbox[1] = {name = fb.name, amount = last, temperature = fb.temperature}
                    else
                        tank.fluidbox[1] = nil
                    end
                    current = last
                end

                info.last_amount = current
            end
        end
    end
end

script.on_nth_tick(UNLINKED_TANK_CHECK_INTERVAL, enforce_unlinked_tanks_extract_only)

-- GUI réseau
local function show_network_gui(player, chest)
    close_frame(player, gui_frame)
    local f = player.gui.screen.add{
        type = "frame",
        name = gui_frame,
        caption = ((chest_types[chest.name] and chest_types[chest.name].display) or (tank_types[chest.name] and tank_types[chest.name].display) or chest.name),
        direction = "vertical"
    }
    f.tags = { chest_unit_number = chest.unit_number, chest_name = chest.name }

    -- top flow
    local top_flow = f.add{ type="flow", direction="vertical" }
    local chest_info = chest_types[chest.name] or tank_types[chest.name] or { display = chest.name }
	local sel = get_link_id(chest)
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
	

	-- flow vertical pour recherche + dropdown + boutons
	local flow2 = top_flow.add{ type="flow", direction="vertical" }
	flow2.add{ type="textfield", name = gui_search_field, tooltip = {"dim-search-tooltip"} }
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

-- recherche en direct dans la liste de réseaux
script.on_event(defines.events.on_gui_text_changed, function(e)
    if e.element.name ~= gui_search_field then return end
    local player = game.get_player(e.player_index)
    local f = player.gui.screen[gui_frame]
    if not f or not f.valid then return end
    refresh_dropdown(player, f.tags.chest_name, e.element.text)
end)

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
                local search = find_search_field(f)
                refresh_dropdown(player, f.tags.chest_name, search and search.text)
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
				if tank_types[chest.name] then
					local fb = chest.fluidbox[1]
					if fb and fb.amount and fb.amount > 0.001 then
						game.print({"dim-tank-not-empty"})
						return
					end
					add_tank_to_network(chest, id)
				else
					add_chest_to_network(chest, id)
				end
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
			if get_link_id(chest) == 0 then
				game.print({"dim-chest-not-linked"})
			elseif tank_types[chest.name] then
				remove_tank_from_network(chest, chest.name)
				stop_chest_animation(chest.unit_number)
				game.print({"dim-chest-unlinked"})
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

    -- Vérifier que ce sont des coffres ou réservoirs dimensionnels (même famille)
    local is_chest_pair = chest_types[event.source.name] and chest_types[event.destination.name]
    local is_tank_pair = tank_types[event.source.name] and tank_types[event.destination.name]
    if not (is_chest_pair or is_tank_pair) then return end

    if is_tank_pair then
        storage.reservoirs = storage.reservoirs or {}
        local source_info = storage.reservoirs[event.source.unit_number]
        if source_info then
            storage.reservoirs[event.destination.unit_number] = {
                name = event.destination.name,
                surface = event.destination.surface.name,
                position = event.destination.position,
                link_id = source_info.link_id or 0
            }
            if source_info.link_id and source_info.link_id > 0 then
                local nets = get_networks(event.destination.name)
                for _, net in pairs(nets) do
                    if net.id == source_info.link_id then
                        net.pool = net.pool or {name = nil, amount = 0, temperature = nil}
                        table.insert(net.chests, event.destination.unit_number)
                        if net.pool.name then
                            event.destination.fluidbox.set_filter(1, {name = net.pool.name})
                        end
                        save_networks(event.destination.name, nets)
                        break
                    end
                end
            end
            update_chest_animation(event.destination)
        end
        return
    end

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

-- Détection placement d'un réservoir fluide par joueur ou robot
local function on_tank_built(event, entity)
    storage.reservoirs = storage.reservoirs or {}
    local source_data = nil
    if not source_data and storage.reservoirs[entity.unit_number] then
        source_data = storage.reservoirs[entity.unit_number]
    end

    local link_id = (source_data and source_data.link_id) or 0

    storage.reservoirs[entity.unit_number] = {
        name = entity.name,
        surface = entity.surface.name,
        position = entity.position,
        link_id = link_id,
        last_amount = (source_data and source_data.last_amount) or 0
    }

    if link_id > 0 then
        local nets = get_networks(entity.name)
        for _, net in pairs(nets) do
            if net.id == link_id then
                net.pool = net.pool or {name = nil, amount = 0, temperature = nil}
                table.insert(net.chests, entity.unit_number)
                if net.pool.name then
                    entity.fluidbox.set_filter(1, {name = net.pool.name})
                end
                save_networks(entity.name, nets)
                break
            end
        end
    end

    update_chest_animation(entity)
end

-- Détection placement par joueur ou robot
local function on_chest_built(event)
    local entity = event.created_entity or event.entity
    if entity and tank_types[entity.name] then
        on_tank_built(event, entity)
        return
    end
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
    if entity and tank_types[entity.name] then
        storage.reservoirs = storage.reservoirs or {}
        local info = storage.reservoirs[entity.unit_number]
        if info and info.link_id and info.link_id > 0 then
            remove_tank_from_network(entity.unit_number, entity.name)
        end
        storage.reservoirs[entity.unit_number] = nil
        stop_chest_animation(entity.unit_number)
        return
    end
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
    if e.entity and (chest_types[e.entity.name] or tank_types[e.entity.name]) then
        local player = game.get_player(e.player_index)
        show_network_gui(player, e.entity)
    end
end)

-- fermeture GUI
script.on_event(defines.events.on_gui_closed, function(e)
    if e.entity and (chest_types[e.entity.name] or tank_types[e.entity.name]) then
        local player = game.get_player(e.player_index)
        close_frame(player, gui_frame)
		close_frame(player, gui_button_ok)
        local flow = player.gui.screen[mod_gui_flow_name]
        if flow and flow.valid then
            flow.destroy()
        end
    end
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