extends Spatial

export var gradient: Gradient

var health_percent

func _ready():
	$Particles.emitting = true
	$Particles.process_material.color = gradient.interpolate(1.0 - health_percent)
	yield(get_tree().create_timer(2),"timeout")
	queue_free()

func particles_look_at(normal):
	$Particles.look_at($Particles.global_translation + normal, Vector3.UP)
