class_name ActionAnimation
extends Resource

@export var impact_animation: PackedScene
@export var projectile_animation: PackedScene
@export var projectile_color: Color = Color.WHITE
@export var projectile_texture_override: Texture2D
@export var travel_speed: float = INF
@export var does_contact: bool = false

var contact_duration := 0.02
var tree = Engine.get_main_loop() as SceneTree

func execute(actor: Char, target: Vector2i):
	if target.x > actor.grid_position.x:
		actor.sprite2d.flip_h = true
	elif target.x < actor.grid_position.x:
		actor.sprite2d.flip_h = false
	if does_contact:
		var tween := actor.create_tween()
		var offset_target := Vector2(target - actor.grid_position) * Consts.TILE_SIZE
		tween.tween_property(actor.sprite, "offset", offset_target, contact_duration)
		await tween.finished

	if travel_speed != INF and projectile_animation:
		var projectile : ProjectileNode = projectile_animation.instantiate()
		if projectile_texture_override:
			projectile.set_texture(projectile_texture_override)
		projectile.global_position = actor.global_position
		var target_world := World.grid_to_world(target)
		projectile.set_direction(target_world)
		projectile.set_color(projectile_color)
		tree.current_scene.add_child(projectile)
		
		# make the projectile travel from the actor to the target
		var tween := actor.create_tween()
		var duration := actor.position.distance_to(target_world) / travel_speed
		tween.tween_property(projectile, "position", target_world, duration)
		await tween.finished
		projectile.queue_free()
	
	# impact animation
	if impact_animation:
		var animation := impact_animation.instantiate() as AnimatedSprite2D
		animation.global_position = World.grid_to_world(target)
		tree.current_scene.add_child(animation)
		await animation.animation_finished
	
	if does_contact:
		var tween := actor.create_tween()
		tween.tween_property(actor.sprite, "offset", Vector2.ZERO, contact_duration)
		await tween.finished
