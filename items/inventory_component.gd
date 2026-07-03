class_name InventoryComponent
extends RefCounted

var owner: Char
var items: Array[Item]
var item_limit: int
var gold: int
var card_rewards: int

func _init(owner: Char, item_limit: int) -> void:
	self.items = []
	self.gold = 0
	self.owner = owner
	self.item_limit = item_limit

func is_full() -> bool:
	return item_limit <= len(items)

func use_item(item: Item, actions_ind: int, pos: Vector2i) -> void:
	var action := item.item_actions[actions_ind]
	var successful := action.use(owner, pos)
	# discard the item after use
	if successful:
		remove_item(item)

func add_item(item: Item) -> bool:
	if len(items) >= item_limit:
		return false

	items.push_back(item)
	EventBus.inventory_updated.emit(owner)
	return true

func remove_item(item: Item) -> void:
	items.erase(item)
	EventBus.inventory_updated.emit(owner)

func remove_at(ind: int) -> void:
	items.pop_at(ind)
	EventBus.inventory_updated.emit(owner)

func add_gold(value: int) -> void:
	gold += value
	EventBus.update_gold.emit(owner)

func add_card_reward() -> void:
	card_rewards += 1
	EventBus.inventory_updated.emit(owner)

func claim_card_rewards() -> int:
	var val := card_rewards
	card_rewards = 0
	EventBus.inventory_updated.emit(owner)
	return val
