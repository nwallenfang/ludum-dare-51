extends Node

export var icon: Texture
export var event_name: String

func event():
	$Tween.interpolate_property(Game.player.get_node("%Head/Camera"), "fov", 70, 120, .5)
	$Tween.start()

func end_event():
	$Tween.interpolate_property(Game.player.get_node("%Head/Camera"), "fov", 120, 70, .5)
	$Tween.start()
