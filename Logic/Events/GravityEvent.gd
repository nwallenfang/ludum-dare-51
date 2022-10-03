extends Node

export var icon: Texture
export var event_name: String

var saved_gravity = 29.4

func event():
	# Revert the effect of the gravity_modifier
	Game.player.gravity = 0.5 * saved_gravity
	print("gravity event ", event_name)

func end_event():
	print("End gravity event", event_name)
	Game.player.gravity = saved_gravity
