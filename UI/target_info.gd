extends CharInfo2

var visible_enemies : Array[Char]
var stale := true
var ind := -1

func _ready():
	super._ready()
	# stale the visible enemies list every time user input is requested
	EventBus.user_input_requested.connect(turn_updated)
	EventBus.character_hovered.connect(set_character)
	EventBus.attack_button_pressed.connect(_on_attack_button_button_up)

func _unhandled_input(event: InputEvent) -> void:
	if visible and event.is_action_released("change_target"):
		find_different_char()
		EventBus.camera_move_requested.emit(character.grid_position)

func turn_updated(ch: Char):
	stale = true
	if !is_instance_valid(character) or !visible or !character.visible:
		find_evil_visible_actor()
		find_different_char()

func set_character(ch: Char):
	if ch == character:
		return
	if character != null:
		character.visibility_changed.disconnect(find_different_char)
		character.char_died.disconnect(find_different_char)
		character.char_next_floor.disconnect(find_different_char)
		character.target_indicator.hide()
	super.set_character(ch)
	character.visibility_changed.connect(find_different_char)
	character.char_died.connect(find_different_char)
	character.char_next_floor.connect(find_different_char)
	character.target_indicator.show()
	change_state_label(ch)

func find_different_char():
	find_evil_visible_actor()
	for i in range(len(visible_enemies)):
		ind = (ind + 1) % len(visible_enemies)
		var next_char := visible_enemies[ind]
		if is_instance_valid(next_char) and !next_char.is_dead():
			set_character(next_char)
			next_char.spawn_indicator_particle()
			show()
			return
	hide()

func find_evil_visible_actor():
	if stale:
		stale = false
		ind = -1
		visible_enemies.clear()
		# find the visible actors in the user controlled character
		for ch in ActorManager.get_user_controlled_chars():
			for visible_ch in ch.visible_actors:
				if visible_ch.alignment == Char.Alignment.EVIL:
					visible_enemies.push_back(visible_ch)

func _on_switch_button_button_up() -> void:
	find_different_char()
	EventBus.camera_move_requested.emit(character.grid_position)

func _on_attack_button_button_up() -> void:
	if !Globals.listening_user_input or !is_instance_valid(character):
		return
	var user_controlled_actors := ActorManager.get_user_controlled_chars()
	if user_controlled_actors.is_empty():
		return
	Globals.listening_user_input = false
	var hero := user_controlled_actors[0]
	var turn_passed := await AttackOnlyAction.new(hero, character).execute()
	if turn_passed:
		EventBus.turn_ended.emit()
	else:
		Globals.listening_user_input = true
