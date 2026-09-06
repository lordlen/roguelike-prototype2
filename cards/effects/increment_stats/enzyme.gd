class_name Enzyme
extends CardEffect

@export var value := 2

func get_identifier() -> String:
	return "enzyme"

func get_description() -> String:
	return 'Increase attack by n times "Slimed"s in the target deck.'

func get_numeric() -> String:
	return "n"

func do(actor: Char, target_pos: Vector2i, card: CardInstance) -> void:
	# count how many slimes are in the deck
	var target_char := ActorManager.get_actor_in_position(target_pos)
	if is_instance_valid(target_char):
		var target_cards := target_char.deck.get_all_card_instances()
		# count slimes
		var num_slimed := 0
		for c in target_cards:
			if c.card_name == "Slimed":
				num_slimed += 1

		var tmp_atk_up := TmpAtkUp.new()
		tmp_atk_up.atk_value = value * num_slimed
		tmp_atk_up.do(actor, target_pos, card)
	card_effect_finished.emit()

func get_shortform(card: CardInstance) -> String:
	return "%d %s" % [value, super.get_shortform(card)]
