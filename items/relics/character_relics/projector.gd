extends Relic

func on_move_effect(actor: Char):
	if actor.deck.offhand:
		var tmp_def_up := TmpDefUp.new()
		tmp_def_up.def_value = 1
		tmp_def_up.do(actor, actor.grid_position, actor.deck.offhand)
