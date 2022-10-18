extends Node

export var icon: Texture
export var event_name: String
export var size_multiplier: float = 1.5
var is_pickup

func event():
	Game.player.get_node("%Banana").visible = true
	Game.player.get_node("%GunStandard").visible = false
	Events.banana = true

func end_event():
	Game.player.get_node("%Banana").visible = false
	Game.player.get_node("%GunStandard").visible = true
	Events.banana = false
