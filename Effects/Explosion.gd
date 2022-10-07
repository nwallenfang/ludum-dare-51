extends Spatial

export var damage := 40

func _ready():
	for area in $Area.get_overlapping_areas():
		if area.get_parent().has_method("damage"):
			area.get_parent().damage(damage)
	$BoomStream.play()
	$Particles.emitting = true
	$Particles2.emitting = true
	$Particles3.emitting = true
	$Tween.interpolate_property($OmniLight, "light_energy", 10.0, 0.0, .8)
	$Tween.start()
	yield(get_tree().create_timer(.1),"timeout")
	$Area.queue_free()
	yield(get_tree().create_timer(1.5),"timeout")
	queue_free()
	
	

func _on_Area_area_entered(area):
	if area.get_parent().has_method("damage"):
		area.get_parent().damage(damage)
		
