extends Spatial

export var speed := .5

func _physics_process(delta):
	self.global_translation.y += speed * delta
	if Game.player.global_translation.y <= self.global_translation.y:
		Game.player.get_hurt()
