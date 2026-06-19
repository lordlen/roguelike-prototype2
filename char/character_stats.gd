class_name CharacterStats
extends Resource

@export var texture: Texture2D
@export var character_name: String
@export var alignment: Char.Alignment
@export var user_controlled: bool
@export var traversal: Char.Traversal

# stats like hp
@export var max_hp: int

@export var vision_range: int = 8
@export var scent_range: int = 1

# ai
@export var sleeping: AiState = SleepingState.new()
@export var wandering: AiState = WanderingState.new()
@export var hunting: HuntingState = HuntingState.new()

@export var cards: Array[CardResource]
