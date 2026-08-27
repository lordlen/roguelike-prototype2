class_name Poison
extends CardEffect

@export var value: int

func get_identifier() -> String:
	return "poison"
	
func get_description() -> String:
	return 'Add n lose hp to "Poison".'

func get_numeric() -> String:
	return "n"

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	var poison = target_char.deck.find_card("Poison")
	if poison == null:
		var poison_resource := load("res://cards/card_resources/special/poison.tres")
		poison = CardInstance.new(poison_resource)
		target_char.deck.add_to_discard(poison)
		target_char.char_card_added.emit(poison)

	# increase value of lose hp
	var lose_hp := LoseHp.new()
	lose_hp.value = value
	CardEffect.combine_effects(poison.on_draw_effects, [lose_hp])
	card_effect_finished.emit()

func combine_effect(other_effect: CardEffect) -> CardEffect:
	if !self.is_same_effect(other_effect):
		return self
	
	value += (other_effect as Poison).value
	return self

func get_shortform(card: CardInstance) -> String:
	return "%d %s" % [value, super.get_shortform(card)]
