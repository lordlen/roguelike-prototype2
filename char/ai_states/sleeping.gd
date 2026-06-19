class_name SleepingState
extends AiState

func get_state_name() -> String:
	return "Sleeping"

func act(actor: Char) -> Array[Action]:
	# TODO: Awaken logic
	var enemy_seen := actor
	for ch: Char in actor.visible_actors:
		if ch.alignment != actor.alignment:
			# swap states
			enemy_seen = ch
			break
	if enemy_seen != actor:
		actor.hunt_with_team(enemy_seen)
		return actor.curr_state.act(actor)
	return []
