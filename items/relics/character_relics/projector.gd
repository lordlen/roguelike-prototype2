extends Relic

func on_move_effect(actor: Char):
	var tmp_def_up := TmpDefUp.new()
	tmp_def_up.def_value = 1
	for card in actor.deck.get_all_card_instances():
		tmp_def_up.do(actor, actor.grid_position, card)
