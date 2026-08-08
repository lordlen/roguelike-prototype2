class_name EventDialog
extends Panel

func _ready() -> void:
	EventBus.event_requested.connect(_on_event_requested)

func _on_event_requested(actor: Char, title: String, description: String, options: Array[ItemAction]):
	set_title(title)
	set_description(description)
	set_options(actor, options)
	visible = true

func set_title(title: String):
	$Title.text = title

func set_description(description: String):
	$Description.text = description

func set_options(owner: Char, options: Array[ItemAction]):
	# clear all buttons
	for button in $Options.get_children():
		$Options.remove_child(button)
		button.queue_free()
	
	var options_button_scene: PackedScene = load("res://UI/options_button.tscn")
	# add new buttons
	for action in options:
		if !action.is_usable(owner):
			continue
		var options_button : OptionsButton= options_button_scene.instantiate()
		options_button.set_action(action)
		options_button.set_user(owner)
		options_button.pressed.connect(_on_button_pressed)
		$Options.add_child(options_button)

func _on_button_pressed():
	visible = false
	EventBus.event_concluded.emit()
