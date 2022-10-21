extends Spatial

func _ready():
	for c in get_children():
		if c is Particles:
			c.one_shot = true
			c.emitting = true
		for cc in c.get_children():
			if cc is Particles:
				cc.one_shot = true
				cc.emitting = true
	$LaserDrawer.draw_line(self.global_translation, self.global_translation+ Vector3.UP * .01)
	
	
#	yield(get_tree().create_timer(2.0), "timeout")
#	self.queue_free()
