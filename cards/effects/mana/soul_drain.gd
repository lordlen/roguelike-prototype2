class_name SoulDrain
extends CardEffect

@export var value: int

func get_identifier() -> String:
	return "soul_drain"
	
func get_description() -> String:
	return 'Add the "feed" effect to "Cast Spell".'

func get_numeric() -> String:
	return "n"

func get_all_nested_card_effects() -> Array[CardEffect]:
	return [self, Feed.new()]

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	# check if "cast spell" is in the deck.
	var cs = actor.deck.find_card("Cast Spell")
	if cs == null:
		# create a cast spell card
		var cs_resource := load("res://cards/card_resources/special/cast_spell.tres")
		cs = CardInstance.new(cs_resource)
		actor.deck.add_to_discard(cs)
		actor.char_card_added.emit(cs)

	# increase cs atk by value
	var feed := Feed.new()
	feed.is_temp = true
	feed.value = value
	CardEffect.combine_effects(cs.attack_effects, [feed])
	card_effect_finished.emit()

func combine_effect(other_effect: CardEffect) -> CardEffect:
	if !self.is_same_effect(other_effect):
		return self
	
	value += (other_effect as SoulDrain).value
	return self

func get_shortform(card: CardInstance) -> String:
	return "%d %s" % [value, super.get_shortform(card)]
