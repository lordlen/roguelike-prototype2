class_name CardEffect
extends Resource

@export var description: String

func do(actor: Char, target_char: Char, card: CardInstance, path: Array[Vector2i]) -> void:
	pass

func get_description() -> String:
	return description
