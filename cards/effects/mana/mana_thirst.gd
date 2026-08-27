class_name ManaThirst
extends CardEffect

@export var value: int

func get_identifier() -> String:
	return "mana_thirst"
	
func get_description() -> String:
	return 'Add the "Invert" effect to "Cast Spell"'

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	# check if "cast spell" is in the deck.
	var cs = actor.deck.find_card("Cast Spell")
	if cs == null:
		# create a cast spell card
		var cs_resource := load("res://cards/card_resources/special/cast_spell.tres")
		cs = CardInstance.new(cs_resource)
		actor.char_card_added.emit(cs)
		actor.deck.add_to_discard(cs)

	# increase cs atk by value
	CardEffect.combine_effects(cs.attack_effects, [Invert.new()])
	card_effect_finished.emit()

func combine_effect(other_effect: CardEffect) -> CardEffect:
	if !self.is_same_effect(other_effect):
		return self
	
	value += (other_effect as Mana).value
	return self
