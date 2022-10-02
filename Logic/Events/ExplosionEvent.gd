extends Node

export var icon: Texture
export var event_name: String
export var size_multiplier: float = 1.5

func event():
	Events.explosion_on_shot = true

func end_event():
	Events.explosion_on_shot = false
