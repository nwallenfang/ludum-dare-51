extends Spatial

const EXPLOSION = preload("res://Effects/Explosion.tscn")
func damage(amount: int, _damage_position: Vector3, damaged_by_laser: bool):
	# Delay the new explosion a bit, so that chains of barrels are more satisfying
	if !damaged_by_laser:
		yield(get_tree().create_timer(0.2), "timeout")
	var explosion = EXPLOSION.instance()
	get_tree().current_scene.add_child(explosion)
	explosion.global_translation = self.global_translation
	queue_free()
