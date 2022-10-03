extends Spatial

func _ready():
	$Particles.emitting = true
	yield(get_tree().create_timer(2),"timeout")
	queue_free()

func particles_look_at(normal):
	$Particles.look_at($Particles.global_translation + normal, Vector3.UP)
