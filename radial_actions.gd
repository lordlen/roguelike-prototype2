extends Control

@onready var show_button := $ShowButton
@onready var options := $Options
var on_up: Callable

func _on_show_button_button_down() -> void:
	show_button.self_modulate = Color.TRANSPARENT
	options.show()

func _on_show_button_button_up() -> void:
	on_up.call()
	EventBus.item_description_hidden.emit()
	show_button.self_modulate = Color.WHITE
	options.hide()

func _on_wait_mouse_entered() -> void:
	on_up = EventBus.wait_button_pressed.emit
	var text :=\
"""Wait (space)
Pass your turn"""
	EventBus.item_description_requested.emit(text)

func _on_swap_mouse_entered() -> void:
	on_up = EventBus.swap_button_pressed.emit
	var text :=\
"""Swap (z)
Swap your main and off hands."""
	EventBus.item_description_requested.emit(text)

func _on_defend_mouse_entered() -> void:
	on_up = EventBus.defend_button_pressed.emit
	var text :=\
"""Block (c)
Use the off-hand to block, negating more damage than it normally does.
The off-hand is discarded at the end of the turn when blocking successfully."""
	EventBus.item_description_requested.emit(text)

func _on_reshuffle_mouse_entered() -> void:
	on_up = EventBus.reshuffle_button_pressed.emit
	var text :=\
"""Reshuffle (x)
Put the discard pile into the draw pile then shuffle your draw pile."""
	EventBus.item_description_requested.emit(text)

func _on_attack_mouse_entered() -> void:
	on_up = EventBus.attack_button_pressed.emit
	var text :=\
"""Attack
Attack the enemy using your main-hand."""
	EventBus.item_description_requested.emit(text)

func _on_options_mouse_exited() -> void:
	on_up = func(): pass
	EventBus.item_description_hidden.emit()
