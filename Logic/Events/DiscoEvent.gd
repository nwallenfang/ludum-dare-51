extends Node

export var icon: Texture
export var event_name: String
export var disco_material = preload("res://Assets/Materials/Disco.tres")

func event():
	Game.world.get_node("ViewportContainer").material = disco_material
	Events.dancing = true

func end_event():
	Game.world.get_node("ViewportContainer").material = null
	Events.dancing = false
