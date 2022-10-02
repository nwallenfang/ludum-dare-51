extends Spatial

func _ready():
	$Particles.emitting = true
	$Particles2.emitting = true
	$Particles3.emitting = true
	$Tween.interpolate_property($OmniLight, "light_energy", 10.0, 0.0, .8)
	$Tween.start()
	yield(get_tree().create_timer(.1),"timeout")
	$Area.queue_free()
	yield(get_tree().create_timer(1.5),"timeout")
	queue_free()
