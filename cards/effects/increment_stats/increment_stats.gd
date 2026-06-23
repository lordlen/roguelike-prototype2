extends CardEffect

@export var atk_value: int
@export var num_hits: int
@export var card_name: String

func do(actor: Char, target_char: Char, card: CardInstance, path: Array[Vector2i]) -> void:
	for c in actor.deck.draw_pile:
		if c.card_name == card_name:
			c.attack += atk_value
			c.num_hits += num_hits
	
	for c in actor.deck.discard_pile:
		if c.card_name == card_name:
			c.attack += atk_value
			c.num_hits += num_hits
	
	if actor.deck.primary and actor.deck.primary.card_name == card_name:
		actor.deck.primary.attack += atk_value
		actor.deck.primary.num_hits += num_hits
	
	if actor.deck.offhand and actor.deck.offhand.card_name == card_name:
		actor.deck.offhand.attack += atk_value
		actor.deck.offhand.num_hits += num_hits
