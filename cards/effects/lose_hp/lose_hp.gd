extends CardEffect

@export var value: int
func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	actor.take_damage(value)
	card_effect_finished.emit()

func get_description() -> String:
	return self.description % value
