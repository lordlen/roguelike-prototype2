extends TextureButton


@export var is_sorted: bool
var card_list: Array[CardInstance] = []
var card_icon_scene: PackedScene = load("res://card_icon.tscn")

func _on_toggled(toggled_on: bool) -> void:
	$CardList.visible = toggled_on
	EventBus.card_selector_requested.emit(card_list, 0, "")

func set_card_list(cards: Array[CardInstance]):
	$NumCards.text = str(len(cards))
	card_list = cards
	if is_sorted:
		card_list.sort()
	# $CardList.set_card_list(cards, is_sorted)
