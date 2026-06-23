extends CardEffect

@export var value: int
func do(actor: Char, target_char: Char, card: CardInstance, path: Array[Vector2i]) -> void:
	actor.take_damage(value)

func get_description() -> String:
	return self.description % value
