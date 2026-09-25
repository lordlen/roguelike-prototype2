class_name CardVFX
extends CardEffect

@export var animation: ActionAnimation

func do(actor: Char, target_pos: Vector2i, card: CardInstance) -> void:
	await animation.execute(actor, target_pos)
	card_effect_finished.emit()
