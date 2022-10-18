extends Node

export var icon: Texture
export var event_name: String
var is_pickup

func event():
	Game.player.invincible = true
	print("Invincible event", event_name)

func end_event():
	Game.player.invincible = false
	print("End Invincible event", event_name)
