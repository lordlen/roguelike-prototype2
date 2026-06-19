extends CardEffect

@export var atk_value: int
@export var num_hits: int
@export var card_name: String

func do(attacker: Char, defender: Char, card: CardInstance, path: Array[Vector2i]) -> void:
	for c in attacker.deck.draw_pile:
		if c.card_name == card_name:
			c.attack += atk_value
			c.num_hits += num_hits
	
	for c in attacker.deck.discard_pile:
		if c.card_name == card_name:
			c.attack += atk_value
			c.num_hits += num_hits
	
	if attacker.deck.primary and attacker.deck.primary.card_name == card_name:
		attacker.deck.primary.attack += atk_value
		attacker.deck.primary.num_hits += num_hits
	
	if attacker.deck.offhand and attacker.deck.offhand.card_name == card_name:
		attacker.deck.offhand.attack += atk_value
		attacker.deck.offhand.num_hits += num_hits
