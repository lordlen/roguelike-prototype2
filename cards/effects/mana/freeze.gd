class_name Freeze
extends CardEffect

@export var value: int

func get_identifier() -> String:
	return "freeze"
	
func get_description() -> String:
	return 'Add the "-n all_tmp_atk_up" effect to "Cast Spell"'

func get_numeric() -> String:
	return "n"

func get_all_nested_card_effects() -> Array[CardEffect]:
	var effect := AllTmpAtkUp.new()
	effect.target = Target.ENEMY
	return [self, effect]

func do(actor: Char, target_pos: Vector2i, card: CardInstance) -> void:
	# check if "cast spell" is in the deck.
	var cs = actor.deck.find_card("Cast Spell")
	if cs == null:
		# create a cast spell card
		var cs_resource := load("res://cards/card_resources/special/cast_spell.tres")
		cs = CardInstance.new(cs_resource)
		actor.char_card_added.emit(cs)
		actor.deck.add_to_discard(cs)

	var atk_down := AllTmpAtkUp.new()
	atk_down.atk_value = -value
	atk_down.target = Target.ENEMY
	CardEffect.combine_effects(cs.attack_effects, [atk_down])
	card_effect_finished.emit()

func combine_effect(other_effect: CardEffect) -> CardEffect:
	if !self.is_same_effect(other_effect):
		return self
	
	value += (other_effect as Freeze).value
	return self

func get_shortform(card: CardInstance) -> String:
	return "%d %s" % [value, super.get_shortform(card)]
