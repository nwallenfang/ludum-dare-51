extends Node

export var icon: Texture
export var event_name: String

func event():
	Game.get_tree().call_group("tilting", "tilt")
	print("Tilt event", event_name)
