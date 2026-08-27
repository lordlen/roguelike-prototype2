class_name CardResource
extends Resource

enum Rarity {
	COMMON = 0,
	UNCOMMON = 1,
	RARE = 2,
	NONE = 3
}

const max_stats = 100

@export var texture: Texture2D

@export var name: String

@export var rarity: Rarity

@export var attack: int:
	set(value):
		attack = clamp(value, 0, max_stats)
@export var defense: int:
	set(value):
		defense = clamp(value, 0, max_stats)
@export var num_hits: int:
	set(value):
		num_hits = clamp(value, 0, max_stats)
@export var range: int:
	set(value):
		range = clamp(value, 0, max_stats)
@export var is_dodge: bool
@export var exhausts: bool
@export var is_innate: bool
@export var is_ethereal: bool
@export var is_instant: bool

@export var attack_effects: Array[CardEffect]
@export var defense_effects: Array[CardEffect]
@export var on_use_effects: Array[CardEffect]
@export var on_hit_effects: Array[CardEffect]
@export var on_took_damage_effects: Array[CardEffect]
@export var on_move_effects: Array[CardEffect]
@export var on_discard_effects: Array[CardEffect]
@export var on_draw_effects: Array[CardEffect]

func combine(other_card: CardResource) -> CardResource:
	# create a completely new card resource
	var new_card := self.duplicate(true)
	# add the stats of the other card
	new_card.attack += other_card.attack
	new_card.defense += other_card.defense
	# take the maximum of number of hits rather than adding
	new_card.num_hits = max(new_card.num_hits, other_card.num_hits)
	new_card.range = max(new_card.range, other_card.range)
	
	# only keep dodge if both are dodge
	new_card.is_dodge = new_card.is_dodge and other_card.is_dodge
	new_card.exhausts = new_card.exhausts or other_card.exhausts
	new_card.is_innate = new_card.is_innate or other_card.is_innate
	new_card.is_ethereal = new_card.is_ethereal or other_card.is_ethereal
	new_card.is_instant = new_card.is_instant or other_card.is_instant
	
	# now effects need to be added to each other
	new_card.attack_effects = CardEffect.combine_effects(new_card.attack_effects, other_card.attack_effects)
	new_card.defense_effects = CardEffect.combine_effects(new_card.defense_effects, other_card.defense_effects)
	new_card.on_use_effects = CardEffect.combine_effects(new_card.on_use_effects, other_card.on_use_effects)
	new_card.on_hit_effects = CardEffect.combine_effects(new_card.on_hit_effects, other_card.on_hit_effects)
	new_card.on_took_damage_effects = CardEffect.combine_effects(new_card.on_took_damage_effects, other_card.on_took_damage_effects)
	new_card.discard_effects = CardEffect.combine_effects(new_card.discard_effects, other_card.discard_effects)
	new_card.on_draw_effects = CardEffect.combine_effects(new_card.on_draw_effects, other_card.on_draw_effects)
	return new_card
