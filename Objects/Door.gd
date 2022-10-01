extends Spatial


func _process(delta):
	if Game.level.has_key:
		self.queue_free()
