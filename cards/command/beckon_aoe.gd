class_name BeckonAoe
extends CardEffect

@export var radius : int = 1

func get_identifier() -> String:
	return "beckon_aoe"
	
func get_description() -> String:
	return 'Direct wandering enemies within n tiles to my location.'

func get_numeric() -> String:
	return "n"

func do(actor: Char, target_char: Char, card: CardInstance) -> void:
	var position := Globals.floor_map.get_area(actor.grid_position, radius)
	var chars := ActorManager.get_actors_in_positions(position)
	
	for ch in chars:
		if ch.alignment == actor.alignment and !ch.user_controlled\
		and ch.curr_state in [ch.wandering_state, ch.sleeping_state]:
			var map := target_char.get_flow_map(ch.traversal)
			ch.wander_with_map(map)
	card_effect_finished.emit()

func get_shortform(card: CardInstance) -> String:
	return "%d %s" % [radius, super.get_shortform(card)]
