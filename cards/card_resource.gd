class_name CardResource
extends Resource

const card_map := {
	strike = "res://cards/card_resources/strike.tres",
	defend = "res://cards/card_resources/defend.tres",
	dodge = "res://cards/card_resources/dodge.tres",
	claw = "res://cards/card_resources/claw.tres",
	lunge = "res://cards/card_resources/lunge.tres",
	croak = "res://cards/card_resources/croak.tres",
	tongue_lash = "res://cards/card_resources/tongue_lash.tres",
	toxic_body = "res://cards/card_resources/toxic_body.tres"
}

@export var texture: Texture2D

@export var name: String

@export var attack: int
@export var defense: int
@export var num_hits: int
@export var range: int
@export var is_dodge: bool
@export var exhausts: bool
@export var is_innate: bool
@export var is_ethereal: bool
@export var is_swift: bool

@export var attack_effects: Array[CardEffect]
@export var defense_effects: Array[CardEffect]
@export var on_hit_effects: Array[CardEffect]
