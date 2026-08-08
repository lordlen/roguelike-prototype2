extends Panel

var char_info: PackedScene = load("res://UI/char_info2.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.new_actor_added.connect(on_actor_added)
	EventBus.character_fov_updated.connect(_update_visibility)

func on_actor_added(ch: Char):
	var actor_info := char_info.instantiate()
	actor_info.set_character(ch)
	actor_info.update(ch)
	$ScrollContainer/CharInfoList.add_child(actor_info)

func _update_visibility(ch: Char):
	if ch.is_user_controlled():
		for child: CharInfo2 in $ScrollContainer/CharInfoList.get_children():
			child.visible = child.character.visible
