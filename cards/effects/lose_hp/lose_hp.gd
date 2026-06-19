extends CardEffect

@export var value: int
func do(attacker: Char, defender: Char, card: CardInstance, path: Array[Vector2i]) -> void:
	attacker.take_damage(value)

func get_description() -> String:
	return self.description.format(value)
