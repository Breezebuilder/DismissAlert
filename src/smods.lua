if not SMODS then
	logger.log_warn('SMODS initialiser could not find SMODS instance')
	return
end

SMODS.Atlas({
	key = 'modicon',
	path = 'icon.png',
	px = 32,
	py = 32
})

SMODS.current_mod.description_loc_vars = function(self)
	return {
		scale = 1.2,
		background_colour = G.C.CLEAR
	}
end