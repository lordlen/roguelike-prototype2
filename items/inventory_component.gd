class_name InventoryComponent
extends RefCounted

var owner: Char
var items: Array[Item]
var relics: Array[Relic]
var item_limit: int
var gold: int
var card_rewards: int

func _init(owner: Char, item_limit: int) -> void:
	self.items = []
	self.relics = []
	self.gold = 0
	self.owner = owner
	self.item_limit = item_limit
	owner.char_card_added.connect(on_card_added)
	owner.char_attacked.connect(on_attack)
	owner.char_defended.connect(on_defend)
	owner.char_reshuffled.connect(on_reshuffle)
	owner.char_is_hit.connect(on_hit)
	owner.char_took_damage.connect(on_took_damage)

func on_relic_added():
	for relic in relics:
		relic.on_relic_added(owner)

func on_card_added(card_resource: CardResource):
	for relic in relics:
		relic.on_card_added(owner, card_resource)

func on_attack(defender: Char):
	for relic in relics:
		relic.on_attack(owner, defender)

func on_defend():
	for relic in relics:
		relic.on_defend(owner)

func on_reshuffle():
	for relic in relics:
		relic.on_reshuffle(owner)

func on_hit(attacker: Char):
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

func add_relic(relic: Relic):
	on_relic_added()
	relics.push_back(relic)
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
