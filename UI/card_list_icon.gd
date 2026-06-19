extends TextureButton


@export var is_sorted: bool
var card_icon_scene: PackedScene = load("res://card_icon.tscn")

func _on_toggled(toggled_on: bool) -> void:
	$CardList.visible = toggled_on

func set_card_list(cards: Array[CardInstance]):
	$NumCards.text = str(len(cards))
	# $CardList.set_card_list(cards, is_sorted)
