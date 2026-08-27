class_name HealLeader
extends CardEffect

@export var heal_value: int = 1

func get_identifier() -> String:
	return "heal_leader"
	
func get_description() -> String:
	return "Heal the leader by n (reduced by defense)."

func get_numeric() -> String:
	return "n"

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	var target_def := 0 if target_char.deck.offhand == null\
	else target_char.deck.offhand.get_defense()
	var heal_amount : int = max(0, heal_value - target_def)
	actor.leader.take_damage(-heal_amount)
	card_effect_finished.emit()
