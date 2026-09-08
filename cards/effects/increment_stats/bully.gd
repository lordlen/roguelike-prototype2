class_name Bully
extends CardEffect

@export var value := 1

func get_identifier() -> String:
	return "bully"

func get_description() -> String:
	return 'Increase attack by n times number of cards in the target discard pile.'

func get_numeric() -> String:
	return "n"

func do(actor: Char, target_pos: Vector2i, card: CardInstance) -> void:
	# count how many slimes are in the deck
	var target_char := ActorManager.get_actor_in_position(target_pos)
	if is_instance_valid(target_char):
		var num_discard := len(target_char.deck.discard_pile)
		var tmp_atk_up := TmpAtkUp.new()
		tmp_atk_up.atk_value = value * num_discard
		tmp_atk_up.do(actor, target_pos, card)
	card_effect_finished.emit()

func get_shortform(card: CardInstance) -> String:
	return "%d %s" % [value, super.get_shortform(card)]
