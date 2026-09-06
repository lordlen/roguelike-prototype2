class_name Parry
extends CardEffect

@export var value: int

func get_identifier() -> String:
	return "parry"
	
func get_description() -> String:
	return 'Temporarily add "n riposte" on hit.'

func get_numeric() -> String:
	return "n"

func get_all_nested_card_effects() -> Array[CardEffect]:
	return [self, Riposte.new()]

func do(actor: Char, target_pos: Vector2i, card: CardInstance) -> void:
	var riposte := Riposte.new()
	riposte.value = value
	CardEffect.combine_effects(card.on_hit_effects, [riposte])
	card_effect_finished.emit()

func combine_effect(other_effect: CardEffect) -> CardEffect:
	if self.is_same_effect(other_effect):
		self.value = max(self.value, (other_effect as Riposte).value)
	return self

func get_shortform(card: CardInstance) -> String:
	return "%s %s" % [value, super.get_shortform(card)]
