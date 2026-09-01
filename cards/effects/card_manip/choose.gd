class_name ChooseCourier
extends CardEffect

var choices : Array[CardResource] = [
	load("res://cards/card_resources/special/courier1.tres"),
	load("res://cards/card_resources/special/courier2.tres"),
	load("res://cards/card_resources/special/courier3.tres"),
]

func get_identifier() -> String:
	return "courier"

func get_description() -> String:
	var description :='''Choose:
-1 gold. 2 shiv. Recall "Shiv."
-2 gold. 2 shiv_up.
-3 gold. 6 shiv.'''
	return description

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	var card_instances : Array[CardInstance] = []
	for c in choices:
		card_instances.push_back(CardInstance.new(c))
	EventBus.card_selector_requested.emit(card_instances, 1, "Select a card to use.")
	var indices : Array[int] = await EventBus.cards_selected
	var selected_ind := indices[0]
	var selected_card : CardInstance = card_instances[selected_ind]
	await selected_card.do_attack(actor, target_char)
	card_effect_finished.emit()
