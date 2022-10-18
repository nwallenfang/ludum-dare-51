extends Node

export var icon: Texture
export var event_name: String
var is_pickup

func event():
	Game.player.get_node("Head/Gun").autofire = true
	print("autofire event", event_name)

func end_event():
	Game.player.get_node("Head/Gun").autofire = false
	print("end autofire event", event_name)
