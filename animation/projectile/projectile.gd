class_name ProjectileNode
extends Sprite2D


@export var rotation_speed := 0

func _process(delta: float) -> void:
	rotation += rotation_speed * delta

func set_direction(target: Vector2):
	var relative_target := target - global_position
	var angle = Vector2(1, 0).angle_to(relative_target)
	rotation = angle
	$CPUParticles2D.angle_min = -rad_to_deg(angle)
	$CPUParticles2D.angle_max = -rad_to_deg(angle)

func set_color(color: Color):
	modulate = color
