extends Sprite2D

@onready var animation_player := $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("disappear")
	await animation_player.animation_finished
	queue_free()
