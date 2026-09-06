class_name Splash
extends CardEffect

@export var atk_value: int = 1
@export var radius: int = 1

func get_identifier() -> String:
	return "splash"

func get_description() -> String:
	return "Deal n damage to all enemies within radius m around the target."

func get_numeric() -> String:
	return "n m"

func do(attacker: Char, target_pos: Vector2i, card: CardInstance) -> void:
	CardHelper.deal_aoe_damage(atk_value, 1, attacker, target_pos, radius)
	card_effect_finished.emit()


func combine_effect(other_effect: CardEffect) -> CardEffect:
	if !self.is_same_effect(other_effect):
		return self
	
	atk_value += (other_effect as Splash).atk_value
	radius = max((other_effect as Splash).radius, radius)
	return self

func get_shortform(card: CardInstance) -> String:
	return "%s %d %s" % [atk_value, radius, super.get_shortform(card)]
