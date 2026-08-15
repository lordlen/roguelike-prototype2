class_name Mana
extends CardEffect

@export var value: int
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
	cs.attack += value
	card_effect_finished.emit()

func combine_effect(other_effect: CardEffect) -> CardEffect:
	if !self.is_same_effect(other_effect):
		return self
	
	value += (other_effect as LoseHp).value
	return self

func get_full_description(card: CardInstance) -> String:
	return "%d %s" % [value, super.get_full_description(card)]

func get_shortform(card: CardInstance) -> String:
	return "%d %s" % [value, super.get_shortform(card)]
