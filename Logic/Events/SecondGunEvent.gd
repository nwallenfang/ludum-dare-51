extends Node

export var icon: Texture
export var event_name: String
export var size_multiplier: float = 1.5

func event():
	Events.second_gun = true
	Game.player.get_node("%SecondGunAnimation").play("down")

func end_event():
	Events.second_gun = false
	Game.player.get_node("%SecondGunAnimation").play("up")
