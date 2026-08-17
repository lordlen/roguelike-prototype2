class_name Slimy
extends AddCard

func _init() -> void:
	target = Target.ENEMY
	card_resource = load("res://cards/card_resources/special/slimed.tres")

func get_identifier() -> String:
	return "slimy"

func get_description() -> String:
	return 'Add n "Slimed" to the draw pile.'

func get_numeric() -> String:
	return "n"
