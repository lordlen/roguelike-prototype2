class_name Shiv
extends AddCard

func _init() -> void:
	target = Target.SELF
	card_resource = load("res://cards/card_resources/special/shiv.tres")

func get_identifier() -> String:
	return "shiv"

func get_description() -> String:
	return "Add n shivs to the draw pile."

func get_numeric() -> String:
	return "n"
