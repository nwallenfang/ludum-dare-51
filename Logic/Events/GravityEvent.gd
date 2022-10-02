extends Node

export var icon: Texture
export var event_name: String

func event():
	# Revert the effect of the gravity_modifier
	Game.player.gravity /= 2
	print("gravity event ", event_name)

func end_event():
	print("End gravity event", event_name)
	Game.player.gravity *= 2
