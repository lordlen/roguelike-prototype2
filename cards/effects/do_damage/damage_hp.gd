class_name DamageHp
extends CardEffect

func get_identifier() -> String:
	return "damage_hp"

func get_description() -> String:
	return "Deal damage equal to hp (ignores defense)."

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	var damage_fixed := DamageFixed.new()
	damage_fixed.atk_value = actor.curr_hp
	damage_fixed.do(actor,target_char, card)
	card_effect_finished.emit()
