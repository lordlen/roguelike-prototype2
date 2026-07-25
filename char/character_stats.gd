class_name CharacterStats
extends Resource

@export var texture: Texture2D
@export var character_name: String
@export var alignment: Char.Alignment
@export var user_controlled: bool
@export var traversal: Char.Traversal
@export var is_cautious: bool

# stats like hp
@export var min_hp: int
@export var max_hp: int

@export var vision_range: int = 8
@export var scent_range: int = 1

# ai
@export var sleeping: AiState = SleepingState.new()
@export var wandering: AiState = WanderingState.new()
@export var hunting: HuntingState = HuntingState.new()

@export var cards: Array[CardResource]
@export var innate_cards: Array[CardResource]

@export var items: Array[Item]
