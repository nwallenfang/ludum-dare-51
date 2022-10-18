extends Node

export var icon: Texture
export var event_name: String
var is_pickup

func event():
	$Tween.interpolate_property(Game.world.get_node("%InterpolatedCamera"), "fov", 70, 120, .5)
	$Tween.start()

func end_event():
	$Tween.interpolate_property(Game.world.get_node("%InterpolatedCamera"), "fov", 120, 70, .5)
	$Tween.start()
