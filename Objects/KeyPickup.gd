extends Spatial

func _on_Area_area_entered(area):
	Game.level.has_key = true
	self.queue_free()

func _ready():
	while true:
		$Tween.reset_all()
		
		$Tween.interpolate_property(self, "translation", self.translation, self.translation + Vector3(0, 0.5, 0), 1, Tween.TRANS_SINE)
		
		$Tween.start()
		
		yield($Tween, "tween_all_completed")
		
		$Tween.reset_all()
		
		$Tween.interpolate_property(self, "translation", self.translation, self.translation - Vector3(0, 0.5, 0), 1, Tween.TRANS_SINE)
		
		$Tween.start()
		
		yield($Tween, "tween_all_completed")
		
