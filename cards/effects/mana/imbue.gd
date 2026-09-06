class_name Imbue
extends CardEffect

@export var value: int = 1

func get_identifier() -> String:
	return "imbue"
	
func get_description() -> String:
	return 'Add temporary "n mana" effect to all cards in the draw pile.'

func get_numeric() -> String:
	return "n"

func get_all_nested_card_effects() -> Array[CardEffect]:
	return [self, Mana.new()]

func do(actor: Char, target_pos: Vector2i, card: CardInstance) -> void:
	for c in actor.deck.draw_pile:
		var mana := Mana.new()
		mana.value = value
		mana.is_temp = true
		CardEffect.combine_effects(c.on_use_effects, [mana])
	card_effect_finished.emit()

func combine_effect(other_effect: CardEffect) -> CardEffect:
	if !self.is_same_effect(other_effect):
		return self
	
	value += (other_effect as Imbue).value
	return self

func get_shortform(card: CardInstance) -> String:
	return "%d %s" % [value, super.get_shortform(card)]
