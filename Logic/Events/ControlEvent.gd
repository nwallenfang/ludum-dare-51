extends Node

export var icon: Texture
export var event_name: String
var is_pickup

func event():
	Game.player.inverted_controls = true
	print("Control event", event_name)

func end_event():
	Game.player.inverted_controls = false
	print("End Control event", event_name)
