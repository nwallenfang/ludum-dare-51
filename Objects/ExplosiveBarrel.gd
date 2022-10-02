extends Spatial

const EXPLOSION = preload("res://Effects/Explosion.tscn")
func damage(amount: int):
	var explosion = EXPLOSION.instance()
	get_tree().current_scene.add_child(explosion)
	explosion.global_translation = self.global_translation
	queue_free()
