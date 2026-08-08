class_name DamageParticle
extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("disappear")
	await $AnimationPlayer.animation_finished
	queue_free()

func set_color(color: Color):
	$Label.modulate = color
