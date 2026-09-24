extends Sprite2D

@onready var animation_player := $AnimationPlayer

func _ready() -> void:
	animation_player.play("play")
	await animation_player.animation_finished
	queue_free()
