class_name ChooseAtkUp
extends CardEffect

@export var value: int

func get_identifier() -> String:
	return "foresight"

func get_description() -> String:
	return "Pick a card from the draw pile and add n attack temporarily."

func get_numeric() -> String:
	return "n"

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	if len(actor.deck.draw_pile) > 0:
		var draw_pile := actor.deck.draw_pile.duplicate()
		draw_pile.sort_custom(func (a,b): return a.card_name < b.card_name)
		EventBus.card_selector_requested.emit(draw_pile, 1, "Select a card to increase attack.")
		var indices : Array[int] = await EventBus.cards_selected
		var selected_ind := indices[0]
		var selected_card : CardInstance = draw_pile.pop_at(selected_ind)
		var tmp_atk_up := TmpAtkUp.new()
		tmp_atk_up.atk_value = value
		tmp_atk_up.do(actor, target_char, selected_card)
	card_effect_finished.emit()

func get_shortform(card: CardInstance) -> String:
	return "%s %s" % [value, super.get_shortform(card)]
