extends Control

@export var game_scene: PackedScene
@export var feedback_scene: PackedScene

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_packed(game_scene)

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_feedback_button_pressed() -> void:
	$Feedback.show()

func _on_feedback_feedback_success() -> void:
	$FeedbackMessage.show()
	await get_tree().create_timer(5.0).timeout
	$FeedbackMessage.hide()

func _on_feedback_feedback_fail() -> void:
	$FeedbackMessageFail.show()
	await get_tree().create_timer(5.0).timeout
	$FeedbackMessageFail.hide()
