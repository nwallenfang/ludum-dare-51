extends Spatial

func _ready():
	$Particles.emitting = true

func _on_Timer_timeout():
	$Tween.interpolate_property($OmniLight, "light_energy", $OmniLight.light_energy, 0.0, 2.0)
	yield($Tween,"tween_all_completed")
	queue_free()
