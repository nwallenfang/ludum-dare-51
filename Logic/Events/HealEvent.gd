extends Node

export var icon: Texture
export var event_name: String
var is_pickup

func event():
	Game.player.hp = Game.player.max_hp
	Ui.get_node("CanvasLayer/EventBar").update_health_bar(3)

func end_event():
	pass
