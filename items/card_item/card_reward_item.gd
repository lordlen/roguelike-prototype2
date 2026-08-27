class_name CardRewardItem
extends Item

const resource_mapping := {
	CardResource.Rarity.COMMON: "res://items/card_item/common_card_reward.tres",
	CardResource.Rarity.UNCOMMON: "res://items/card_item/uncommon_card_reward.tres",
	CardResource.Rarity.RARE: "res://items/card_item/rare_card_reward.tres"
}

@export var rarity: CardResource.Rarity

func on_pick_up(inventory: InventoryComponent) -> bool:
	inventory.add_card_reward(self)
	return true
