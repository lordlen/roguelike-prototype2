class_name MagicBurstEffect
extends CardEffect

func get_identifier() -> String:
	return "magic_burst"
	
func get_description() -> String:
	return '"Cast Spell" now does AOE damage.'

func do(actor: Char, target_pos: Vector2i, card: CardInstance) -> void:
	# check if "cast spell" is in the deck.
	var cs = actor.deck.find_card("Cast Spell")
	if cs == null:
		# create a cast spell card
		var cs_resource := load("res://cards/card_resources/special/cast_spell.tres")
		cs = CardInstance.new(cs_resource)
		actor.deck.add_to_discard(cs)
	# replace "damage" to damage aoe
	var damageAOE := DamageAoe.new()
	cs.attack_effects[0] = damageAOE
	card_effect_finished.emit()
