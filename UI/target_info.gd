extends CharInfo2

var visible_enemies : Array[Char]
var stale := true
var ind := -1

func _ready():
	super._ready()
	# stale the visible enemies list every time user input is requested
	EventBus.user_input_requested.connect(turn_updated)
	EventBus.character_hovered.connect(set_character)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("change_target"):
		find_different_char()

func turn_updated(ch: Char):
	stale = true
	if !visible or !character.visible:
		find_evil_visible_actor()
		find_different_char()

func set_character(ch: Char):
	if ch == character:
		return
	super.set_character(ch)
	character.visibility_changed.connect(find_different_char)
	character.char_died.connect(find_different_char)

func find_different_char():
	find_evil_visible_actor()
	for i in range(len(visible_enemies)):
		ind = (ind + 1) % len(visible_enemies)
		var next_char := visible_enemies[ind]
		if is_instance_valid(next_char) and !next_char.is_dead():
			set_character(next_char)
			EventBus.camera_move_requested.emit(next_char.grid_position)
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
