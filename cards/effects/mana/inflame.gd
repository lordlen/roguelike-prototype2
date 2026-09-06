class_name Inflame
extends CardEffect

@export var value: int

func get_identifier() -> String:
	return "inflame"
	
func get_description() -> String:
	return 'Add the "n Splash" effect to "Cast Spell"'

func get_numeric() -> String:
	return "n"

func get_all_nested_card_effects() -> Array[CardEffect]:
	return [self, Splash.new()]

func do(actor: Char, target_pos: Vector2i, card: CardInstance) -> void:
	# check if "cast spell" is in the deck.
	var cs = actor.deck.find_card("Cast Spell")
	if cs == null:
		# create a cast spell card
		var cs_resource := load("res://cards/card_resources/special/cast_spell.tres")
		cs = CardInstance.new(cs_resource)
		actor.char_card_added.emit(cs)
		actor.deck.add_to_discard(cs)

	var splash := Splash.new()
	splash.atk_value = value
	splash.radius = 1
	CardEffect.combine_effects(cs.attack_effects, [splash])
	card_effect_finished.emit()

func combine_effect(other_effect: CardEffect) -> CardEffect:
	if !self.is_same_effect(other_effect):
		return self
	
	value += (other_effect as Inflame).value
	return self

func get_shortform(card: CardInstance) -> String:
	return "%d %s" % [value, super.get_shortform(card)]
