extends Panel

var target_selections: int
var num_selections: int
var card_list: Array[CardInstance]

func _ready() -> void:
	EventBus.card_selector_requested.connect(on_requested)

func on_requested(card_list: Array[CardInstance], target_num_selections: int, description: String):
	set_card_list(card_list)
	set_target_num_selections(target_num_selections)
	set_text(description)
	visible = true

func set_card_list(card_list: Array[CardInstance]):
	num_selections = 0
	self.card_list = card_list
	
	# clear current card icon list
	for icon in $ScrollContainer/GridContainer.get_children():
		$ScrollContainer/GridContainer.remove_child(icon)
		icon.queue_free()
	
	var card_icon_scene : PackedScene = load("res://UI/card_icon.tscn")
	for card in card_list:
		var card_icon: CardIcon = card_icon_scene.instantiate()
		card_icon.toggle_mode = true
		card_icon.set_card_data(card)
		card_icon.toggled.connect(_on_icon_toggled)
		$ScrollContainer/GridContainer.add_child(card_icon)

func set_text(txt: String):
	$Label.text = txt

func set_target_num_selections(target_num: int):
	target_selections = target_num

func _on_icon_toggled(toggle: bool):
	if toggle:
		num_selections += 1
	else:
		num_selections -= 1

	if num_selections == target_selections:
		$ConfirmButton.disabled = false
	else:
		$ConfirmButton.disabled = true


func _on_confirm_button_pressed() -> void:
	# find all toggled buttons
	var children := $ScrollContainer/GridContainer.get_children()
	var indices : Array[int] = []
	for i in range(len(children)):
		var card_icon: CardIcon = children[i]
		if card_icon.button_pressed:
			indices.push_back(i)
	
	# emit some signal to indicate the selection. Package indices in the signal
	EventBus.cards_selected.emit(indices)
	visible = false
