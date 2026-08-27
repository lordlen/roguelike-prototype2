class_name InventoryComponent
extends RefCounted

var owner: Char
var items: Array[Item]
var relics: Array[Relic]
var item_limit: int
var gold: int
var card_rewards2: Array[CardRewardItem]
var keys: int

func _init(owner: Char, item_limit: int) -> void:
	self.items = []
	self.relics = []
	self.gold = 0
	self.card_rewards2 = []
	self.owner = owner
	self.item_limit = item_limit
	owner.char_card_added.connect(on_card_added)
	owner.char_attacked.connect(on_attack)
	owner.char_defended.connect(on_defend)
	owner.char_reshuffled.connect(on_reshuffle)
	owner.char_is_hit.connect(on_hit)
	owner.char_took_damage.connect(on_took_damage)
	owner.char_next_floor.connect(on_next_floor)
	owner.char_waited.connect(on_wait)

func on_wait():
	for relic in relics:
		relic.on_wait(owner)

func on_next_floor():
	for relic in relics:
		relic.on_next_floor(owner)

func has_droppable_item() -> bool:
	return len(items) > 0 or gold > 0 or len(card_rewards2) > 0

func on_relic_added():
	for relic in relics:
		relic.on_relic_added(owner)

func on_card_added(card: CardInstance):
	for relic in relics:
		relic.on_card_added(owner, card)

func on_attack(defender: Char):
	for relic in relics:
		relic.on_attack(owner, defender)

func on_defend():
	for relic in relics:
		relic.on_defend(owner)

func on_reshuffle():
	for relic in relics:
		relic.on_reshuffle(owner)

func on_hit(actor: Char, attacker: Char):
	for relic in relics:
		relic.on_hit(owner, attacker)

func on_took_damage():
	for relic in relics:
		relic.on_took_damage(owner)

func on_item_used():
	for relic in relics:
		relic.on_item_used(owner)

func is_full() -> bool:
	return item_limit <= len(items)

func use_item(item: Item, actions_ind: int, pos: Vector2i) -> void:
	var action := item.item_actions[actions_ind]
	var successful := action.use(owner, pos)
	# discard the item after use
	if successful:
		remove_item(item)
		on_item_used()

func add_item(item: Item) -> bool:
	if len(items) >= item_limit:
		return false

	items.push_back(item)
	EventBus.inventory_updated.emit(owner)
	return true

func add_relic(relic: Relic) -> bool:
	on_relic_added()
	relics.push_back(relic)
	EventBus.inventory_updated.emit(owner)
	return true

func clear_relics() -> void:
	relics.clear()
	EventBus.inventory_updated.emit(owner)

func remove_item(item: Item) -> void:
	items.erase(item)
	EventBus.inventory_updated.emit(owner)

func remove_at(ind: int) -> void:
	items.pop_at(ind)
	EventBus.inventory_updated.emit(owner)

func add_gold(value: int) -> void:
	gold += value
	EventBus.update_gold.emit(owner)

func add_card_reward(item: CardRewardItem) -> void:
	card_rewards2.push_back(item)
	EventBus.inventory_updated.emit(owner)

func add_key(value: int) -> void:
	keys += value
	EventBus.inventory_updated.emit(owner)

func claim_card_rewards() -> Array[CardRewardItem]:
	var val := card_rewards2
	card_rewards2 = []
	EventBus.inventory_updated.emit(owner)
	return val

func drop_all_items() -> void:
	# gold
	if gold > 0:
		var item : Gold = load("res://items/gold/gold.tres")
		item.amount = gold
		ItemManager.add_item_to_overworld(item, owner.grid_position)
	# card reward
	for card_item in card_rewards2:
		ItemManager.add_item_to_overworld(card_item, owner.grid_position)
	# potions
	for item in items:
		ItemManager.add_item_to_overworld(item, owner.grid_position)
	
	for k in keys:
		var key_item: Item = load("res://items/key/key.tres")
		ItemManager.add_item_to_overworld(key_item, owner.grid_position)
	
	# do not drop relics. Enemy relics are not meant to be dropped
