class_name Mana
extends CardEffect

@export var value: int

func get_identifier() -> String:
	return "mana"
	
func get_description() -> String:
	return 'Add n attack to "Cast Spell" (Create if absent from the deck).'

func get_numeric() -> String:
	return "n"

func do(actor: Char, target_pos: Vector2i, card: CardInstance) -> void:
	# check if "cast spell" is in the deck.
	var cs = actor.deck.find_card("Cast Spell")
	if cs == null:
		# create a cast spell card
		var cs_resource := load("res://cards/card_resources/special/cast_spell.tres")
		cs = CardInstance.new(cs_resource)
		actor.deck.add_to_discard(cs)
		actor.char_card_added.emit(cs)

	# increase cs atk by value
	cs.attack += value
	card_effect_finished.emit()

func combine_effect(other_effect: CardEffect) -> CardEffect:
	if !self.is_same_effect(other_effect):
		return self
	
	value += (other_effect as Mana).value
	return self

func get_shortform(card: CardInstance) -> String:
	return "%d %s" % [value, super.get_shortform(card)]
