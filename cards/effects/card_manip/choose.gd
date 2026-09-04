class_name Choose
extends CardEffect

@export var choices : Array[CardResource]

func get_identifier() -> String:
	return "choose"

func get_description() -> String:
	var description := "Choose among the options."
	return description

func get_all_nested_card_effects() -> Array[CardEffect]:
	var effects : Array[CardEffect] = [self]
	for c in choices:
		var card := CardInstance.new(c)
		for e in card.get_all_effects():
			effects += e.get_all_nested_card_effects()
	return effects

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

func get_shortform(card: CardInstance) -> String:
	var desc := "[color=orange]%s[/color]\n" % [get_identifier()]
	for c in choices:
		desc += "____________________\n"
		var c_instance := CardInstance.new(c)
		desc += c_instance.get_description()
	return desc
