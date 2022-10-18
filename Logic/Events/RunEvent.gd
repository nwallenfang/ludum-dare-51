extends Node

export var icon: Texture
export var event_name: String
var is_pickup


func event():
	Game.player.infinite_run = true

func end_event():
	Game.player.infinite_run = false
