class_name CharInfo
extends Panel

func _ready() -> void:
	EventBus.character_deck_updated.connect(update_deck)
	EventBus.character_hp_updated.connect(update_hp)
	EventBus.character_died.connect(delete_self)
	EventBus.character_state_changed.connect(change_state_label)

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
		$MarginContainer/HBoxContainer/PrimaryIcon.set_card_data(ch.deck.primary)
		$MarginContainer/HBoxContainer/OffhandIcon.set_card_data(ch.deck.offhand)
		$MarginContainer/HBoxContainer/DrawPile.set_card_list(ch.deck.draw_pile)
		$MarginContainer/HBoxContainer/DiscardPile.set_card_list(ch.deck.discard_pile)

func update_hp(ch: Char):
	if character == ch:
		$TextureProgressBar.value = ch.curr_hp
		$TextureProgressBar/Label.text = "%d / %d" % [ch.curr_hp, ch.max_hp]

func update(ch: Char):
	if character == ch:
		$NameLabel.text = ch.character_name + ("*" if ch.is_elite else "")
		$TextureProgressBar.max_value = ch.max_hp
		$TextureProgressBar.value = ch.curr_hp
		$TextureProgressBar/Label.text = "%d / %d" % [ch.curr_hp, ch.max_hp]

		$MarginContainer/HBoxContainer/PrimaryIcon.set_card_data(ch.deck.primary)
		$MarginContainer/HBoxContainer/OffhandIcon.set_card_data(ch.deck.offhand)
		$MarginContainer/HBoxContainer/DrawPile.set_card_list(ch.deck.draw_pile)
		$MarginContainer/HBoxContainer/DiscardPile.set_card_list(ch.deck.discard_pile)
	
