class_name Relic
extends Item

@export var description: String

func get_description() -> String:
	return description

func on_self_pickup(owner):
	pass

func on_relic_added(owner: Char):
	pass

func on_card_added(owner: Char, card_resource: CardResource):
	pass

func on_attack(actor: Char, defender: Char):
	pass

func on_defend(actor: Char):
	pass

func on_reshuffle(actor: Char):
	pass

func on_hit(actor: Char, attacker: Char):
	pass

func on_took_damage(actor: Char):
	pass

func on_item_used(actor: Char):
	pass

func on_pick_up(inventory: InventoryComponent) -> bool:
	inventory.add_relic(self)
	on_self_pickup(inventory.owner)
	return true
