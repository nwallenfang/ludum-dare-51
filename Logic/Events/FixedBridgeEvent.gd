extends Node

export var icon: Texture
export var event_name: String

func event():
	Game.level.bridge_animation.play("BridgeBoom")
	print("Bridge event", event_name)
