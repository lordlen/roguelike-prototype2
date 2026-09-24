class_name ActionAnimation
extends Resource

@export var projectile: PackedScene
@export var travel_speed: float = INF
@export var does_contact: bool = false

func execute(actor: Char, target: Vector2i):
	if does_contact:
		pass
		# move to target
	if travel_speed == INF:
		# if travel speed is inf, spawn the projectile on the target and play the animation once
		var p := projectile.instantiate() as Node2D
		var tree = Engine.get_main_loop() as SceneTree
		p.global_position = World.grid_to_world(target)
		tree.current_scene.add_child(p)
	else:
		# make the projectile move from actor to target
		pass
	
	if does_contact:
		pass
		# move back to original position
