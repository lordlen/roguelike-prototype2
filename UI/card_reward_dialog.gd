extends Panel

@export var card_reward_generator: CardRewardGenerator
var cards: Array[CardResource] = []

func _ready() -> void:
	EventBus.card_reward_cheated.connect(generate_card_rewards)

func generate_card_rewards():
	var count : Array[int] = [0,0,0]
	for i in range(3):
		count[card_reward_generator.generate_rarity()] += 1
	cards = card_reward_generator.generate_rarity_cards(count)
	display_cards(cards)

func claim_card_rewards():
	var card_rewards := ActorManager.get_user_controlled_chars()[0].inventory.claim_card_rewards()
	var count : Array[int] = [0, 0, 0]
	for card in card_rewards:
		count[card.rarity] += 1
	cards = card_reward_generator.generate_rarity_cards(count)

	display_cards(cards)

func display_cards(cards: Array[CardResource]):
	# remove all old children
	for child in $HBoxContainer.get_children():
		$HBoxContainer.remove_child(child)
		child.queue_free()
	
	var card_icon_scene: PackedScene = load("res://UI/card_display.tscn")
	for card_resource in cards:
		var card_instance := CardInstance.new(card_resource)
		var card_icon : CardDisplay = card_icon_scene.instantiate()
		card_icon.set_card_data(card_instance)
		card_icon.card_icon_pressed.connect(_on_card_reward_pressed)
		$HBoxContainer.add_child(card_icon)
	get_parent().show()

func _on_card_reward_pressed(ind: int) -> void:
	var user_controlled := ActorManager.get_user_controlled_chars()
	if len(user_controlled):
		var char := ActorManager.get_user_controlled_chars()[0]
		char.deck.add_to_deck_list(cards[ind])
		EventBus.character_deck_updated.emit(char)
	get_parent().hide()

func _on_skip_button_pressed() -> void:
	get_parent().hide()
