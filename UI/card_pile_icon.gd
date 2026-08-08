extends TextureButton

@export var is_sorted: bool
var sort_finished: bool
var card_list: Array[CardInstance] = []
	
func set_card_list(cards: Array[CardInstance]):
	$NumCards.text = str(len(cards))
	card_list = cards
	sort_finished = false

func _on_pressed() -> void:
	if is_sorted and !sort_finished:
		card_list.sort_custom(func (a,b):\
		return a.card_name < b.card_name)
		sort_finished = true
	EventBus.card_selector_requested.emit(card_list, 0, "")
