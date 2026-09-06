extends Relic

func on_took_damage(actor: Char):
	if actor.deck.offhand:
		var tmp_def := TmpDefUp.new()
		tmp_def.def_value = 3
		tmp_def.do(actor, actor.grid_position, actor.deck.offhand)
