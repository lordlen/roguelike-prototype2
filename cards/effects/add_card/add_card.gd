class_name AddCard
extends CardEffect

@export var card_resource: CardResource
@export var num_cards: int = 1
@export var target: Target

func do(actor: Char, target_pos: Vector2i, card: CardInstance) -> void:
	var t := actor if target == Target.SELF else ActorManager.get_actor_in_position(target_pos)
	if is_instance_valid(t):
		for i in range(num_cards):
			var card_instance := CardInstance.new(card_resource)
			t.char_card_added.emit(card_instance)
			t.deck.add_to_discard(card_instance)
	card_effect_finished.emit()

func get_shortform(card: CardInstance) -> String:
	return "%s %s" % [num_cards, super.get_shortform(card)]
