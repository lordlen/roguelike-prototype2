class_name Flank
extends CardEffect

@export var atk_value: int

func get_identifier() -> String:
	return "flank"
	
func get_description() -> String:
	return "Increase the attack of this card by n for every hostile character adjacent to the target."

func get_numeric() -> String:
	return "n"

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	# get adjacent characters to the target
	var positions := Globals.floor_map.get_area(target_char.grid_position, 1)
	var chars := ActorManager.get_actors_in_positions(positions)
	# exclude self in this number
	var num_hostile := -1
	for ch in chars:
		if actor.alignment == ch.alignment:
			num_hostile += 1
	var atk_up := TmpAtkUp.new()
	atk_up.atk_value = num_hostile * atk_value
	atk_up.do(actor, target_char, card)
	card_effect_finished.emit()

func combine_effect(other_effect: CardEffect) -> CardEffect:
	if self.is_same_effect(other_effect):
		self.atk_value += (other_effect as Flank).atk_value
	return self

func get_shortform(card: CardInstance) -> String:
	return "%s %s" % [atk_value, super.get_shortform(card)]
