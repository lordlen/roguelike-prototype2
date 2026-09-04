extends Relic
var counter := 0

func get_string_value() -> String:
	return str(counter)

func on_attack(actor: Char, defender: Char):
	counter += 1
	if counter >= 3:
		for card in actor.deck.get_all_card_instances():
			var tmp_def_up := TmpDefUp.new()
			tmp_def_up.def_value = 1
			tmp_def_up.do(actor, defender, card)
		counter = 0
	number_updated.emit()
