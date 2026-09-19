extends Control

@export var game_scene: PackedScene
@export var main_menu_scene: PackedScene

func _on_play_again_pressed() -> void:
	get_tree().change_scene_to_packed(game_scene)

func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_packed(main_menu_scene)
