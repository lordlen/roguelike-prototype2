extends CardEffect

@export var atk_value: int
@export var card_name: String

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	for c in actor.deck.draw_pile:
		if c.card_name == card_name:
			c.attack += atk_value
	
	for c in actor.deck.discard_pile:
		if c.card_name == card_name:
			c.attack += atk_value
	
	if actor.deck.primary and actor.deck.primary.card_name == card_name:
		actor.deck.primary.attack += atk_value
	
	if actor.deck.offhand and actor.deck.offhand.card_name == card_name:
		actor.deck.offhand.attack += atk_value
	
	card_effect_finished.emit()

func get_full_description(card: CardInstance) -> String:
	return "%s %s" % [atk_value, super.get_full_description(card)]

func get_shortform(card: CardInstance) -> String:
	return "%s %s" % [atk_value, super.get_shortform(card)]
