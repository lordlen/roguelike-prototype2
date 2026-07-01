extends AcceptDialog

@export var card_reward_generator: CardRewardGenerator
var cards: Array[CardResource] = []

func generate_card_rewards():
	visible = true
	var card_rewards := ActorManager.get_user_controlled_chars()[0].inventory.claim_card_rewards()
	cards = card_reward_generator.generate_card_rewards(card_rewards)
	
	for ind in range(len(cards)):
		var card_resource := cards[ind]
		var card_instance := CardInstance.new(card_resource)
		var card_icon : CardIcon = $HBoxContainer.get_child(ind)
		card_icon.set_card_data(card_instance)
		card_icon.visible = true
	
	# hide remaining children
	for ind in range(len(cards), len($HBoxContainer.get_children())):
		var card_reward_icon : CardIcon = $HBoxContainer.get_child(ind)
		card_reward_icon.visible = false


func _on_card_reward_1_pressed() -> void:
	self.visible = false
	var user_controlled := ActorManager.get_user_controlled_chars()
	if len(user_controlled):
		var char := ActorManager.get_user_controlled_chars()[0]
		char.deck.add_to_deck_list(cards[0])
		EventBus.character_deck_updated.emit(char)


func _on_card_reward_2_pressed() -> void:
	self.visible = false
	var user_controlled := ActorManager.get_user_controlled_chars()
	if len(user_controlled):
		var char := ActorManager.get_user_controlled_chars()[0]
		char.deck.add_to_deck_list(cards[1])
		EventBus.character_deck_updated.emit(char)


func _on_card_reward_3_pressed() -> void:
	self.visible = false
	var user_controlled := ActorManager.get_user_controlled_chars()
	if len(user_controlled):
		var char := ActorManager.get_user_controlled_chars()[0]
		char.deck.add_to_deck_list(cards[2])
		EventBus.character_deck_updated.emit(char)
