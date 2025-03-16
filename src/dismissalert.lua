DismissAlert = {}

DismissAlert.COLLECTION_NAMES = { 'P_CENTERS', 'P_BLINDS', 'P_TAGS', 'P_SEALS' }

DismissAlert.COLLECTION_UI_LOOKUP = {
	your_collection_vouchers = { 'P_CENTER_POOLS', 'Voucher' },
	your_collection_tarots = { 'P_CENTER_POOLS', 'Tarot' },
	your_collection_planets = { 'P_CENTER_POOLS', 'Planet' },
	your_collection_spectrals = { 'P_CENTER_POOLS', 'Spectral' },
	your_collection_jokers = { 'P_CENTER_POOLS', 'Joker' },
	your_collection_editions = { 'P_CENTER_POOLS', 'Edition' },
	your_collection_boosters = { 'P_CENTER_POOLS', 'Booster' },
	your_collection_blinds = 'P_BLINDS',
	your_collection_tags = 'P_TAGS',
	your_collection_seals = 'P_SEALS'
}

G.FUNCS.dismissalert_temporary_reset_alerts = function(e)
	for _, k in ipairs(DismissAlert.COLLECTION_NAMES) do
		if G[k] then
			for _, v in pairs(G[k]) do
				if type(v) == 'table' and v.alerted == true then v.alerted = false end
			end
		end
	end

	G.REFRESH_ALERTS = true
	set_alerts()
end

G.FUNCS.dismissalert_dismiss_collection_alert = function(e)
	local args = e and e.config and e.config.ref_table or {}
	local success = false

	if args.id == 'collection' or args.id == 'your_collection' then
		for _, collection in ipairs(DismissAlert.COLLECTION_NAMES) do
			if G[collection] then
				for _, v in pairs(G[collection]) do
					if v.discovered then v.alerted = true end
				end
				success = true
			end
		end
	else
		local ref = DismissAlert.COLLECTION_UI_LOOKUP[args.id]
		local collection = G

		if ref == nil then
			print("DismissAlert :: Unknown collection type:")
			print(args)
		else
			if type(ref) == 'string' then
				collection = G[ref]
			elseif type(ref) == 'table' then
				for _, k in ipairs(ref) do
					if not collection[k] then break end
					collection = collection[k]
				end
			end

			if type(collection) ~= 'table' then
				print("DismissAlert :: Could not find collection " .. tostring(args.id) .. " at " .. tostring(ref))
			else
				for _, v in pairs(collection) do
					if type(v) == 'table' and v.discovered then v.alerted = true end
				end
				success = true
			end
		end
	end

	if success and args.alert_uibox_name and G[args.alert_uibox_name] then
		G[args.alert_uibox_name]:remove()
		G[args.alert_uibox_name] = nil
	end

	G:save_progress()
end