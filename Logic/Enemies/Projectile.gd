extends Spatial

var start: Vector3
var end: Vector3
var height: float

var fly_offset : float setget set_fly_offset

func fly(start_: Vector3, end_: Vector3, height_: float, speed: float):
	self.start = start_
	self.end = end_
	self.height = height_
	var start_2d := Vector2(start.x, start.z)
	var end_2d := Vector2(end.x, end.z)
	var dist_2d := start_2d.distance_to(end_2d)
	var time = dist_2d / speed
	$Tween.interpolate_property(self, "global_translation:x", start.x, end.x, time)
	$Tween.interpolate_property(self, "global_translation:z", start.z, end.z, time)
	$Tween.interpolate_property(self, "fly_offset", 0.0, 1.0, time)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	crash()

func set_fly_offset(x: float):
	fly_offset = x
	var base_line : float = lerp(start.y, end.y, x)
	var additional_height = (1.0 - pow(x*2.0-1.0, 2.0)) * height
	self.global_translation.y = base_line + additional_height

const SPLASH = preload("res://Logic/Enemies/ProjectileSplash.tscn")
func crash():
	var splash = SPLASH.instance()
	get_tree().current_scene.add_child(splash)
	splash.global_translation = self.global_translation
	queue_free()


func _on_Hitbox_area_entered(area):
	crash()


func _on_Hitbox_body_entered(body):
	crash()
