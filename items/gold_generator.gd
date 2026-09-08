class_name MoneyGenerator
extends ItemGenerator

@export var low: int
@export var high: int

var rng = RandomNumberGenerator.new()

func get_item() -> Item:
	var gold : Gold = load("res://items/gold/gold.tres")
	var duped := gold.duplicate()
	duped.amount = rng.randi_range(low, high)
	return duped
