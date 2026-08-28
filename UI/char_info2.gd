class_name CharInfo2
extends Panel

func _ready() -> void:
	EventBus.character_deck_updated.connect(update_deck)
	EventBus.character_hp_updated.connect(update_hp)
	EventBus.character_died.connect(delete_self)
	EventBus.character_state_changed.connect(change_state_label)
	EventBus.inventory_updated.connect(update)
	EventBus.update_gold.connect(update)

var character: Char
func set_character(ch: Char):
	character = ch

func delete_self(ch: Char):
	if ch == character:
		self.queue_free()

func change_state_label(ch: Char):
	if ch == character:
		$StateLabel.text = ch.curr_state.get_state_name()

func update_deck(ch: Char):
	if character == ch:
		$Offense.set_card_data(ch.deck.primary)
		$Defense.set_card_data(ch.deck.offhand)
		$DrawPile.set_card_list(ch.deck.draw_pile)
		$DiscardPile.set_card_list(ch.deck.discard_pile)

func update_hp(ch: Char):
	if character == ch:
		$TextureProgressBar.value = ch.curr_hp
		$TextureProgressBar/Label.text = "%d / %d" % [ch.curr_hp, ch.max_hp]

func update(ch: Char):
	if character == ch:
		$NameLabel.text = ch.character_name + ("*" if ch.inventory.has_droppable_item() else "")
		$TextureProgressBar.max_value = ch.max_hp
		$TextureProgressBar.value = ch.curr_hp
		$TextureProgressBar/Label.text = "%d / %d" % [ch.curr_hp, ch.max_hp]

		$Offense.set_card_data(ch.deck.primary)
		$Defense.set_card_data(ch.deck.offhand)
		$DrawPile.set_card_list(ch.deck.draw_pile)
		$DiscardPile.set_card_list(ch.deck.discard_pile)

func _on_camera_button_pressed() -> void:
	var pos := character.grid_position
	character.spawn_indicator_particle()
	EventBus.camera_move_requested.emit(pos)


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var pos := character.grid_position
			character.spawn_indicator_particle()
			EventBus.camera_move_requested.emit(pos)
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			EventBus.character_info_requested.emit(character)
