class_name MainHitsUp
extends CardEffect

@export var value: int

func get_identifier() -> String:
	return "main_hits_up"
	
func get_description() -> String:
	return "Increase the number of hits of the main hand by n."

func get_numeric() -> String:
	return "n"

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	if actor.deck.primary:
		var hits_up := HitsUp.new()
		hits_up.value = value
		hits_up.do(actor, target_char, actor.deck.primary)
	card_effect_finished.emit()

func combine_effect(other_effect: CardEffect) -> CardEffect:
	if self.is_same_effect(other_effect):
		self.value += (other_effect as HitsUp).value
	return self

func get_shortform(card: CardInstance) -> String:
	return "%s %s" % [value, super.get_shortform(card)]
