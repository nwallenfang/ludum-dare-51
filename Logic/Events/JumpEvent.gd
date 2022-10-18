extends Node

export var icon: Texture
export var event_name: String
var is_pickup

func event():
	Game.player.double_jump = true
	print("Jump event", event_name)

func end_event():
	Game.player.double_jump = false
	print("End Jump event", event_name)
