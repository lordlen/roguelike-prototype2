extends CardEffect

func do(actor: Char, target_char: Char, card: CardInstance, path: Array[Vector2i]) -> void:
	var attack_action := AttackOnlyAction.new(actor, target_char)
	attack_action.execute.call_deferred()
	await attack_action.action_finished
	card_effect_finished.emit()
