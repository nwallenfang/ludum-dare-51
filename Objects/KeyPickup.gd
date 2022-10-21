extends Spatial

signal key_collected
func _on_Area_area_entered(area):
	if self.visible:
		emit_signal("key_collected")
		Game.level.has_key = true
		Game.player.play_key_sound()
		self.queue_free()

func _ready():
	$AnimationPlayer.play("dance")
	$Tween.playback_process_mode = Tween.TWEEN_PROCESS_PHYSICS
	while true:
		$Tween.reset_all()
		
		$Tween.interpolate_property(self, "translation", self.translation, self.translation + Vector3(0, 0.5, 0), 1, Tween.TRANS_SINE)
		
		$Tween.start()
		
		yield($Tween, "tween_all_completed")
		
		$Tween.reset_all()
		
		$Tween.interpolate_property(self, "translation", self.translation, self.translation - Vector3(0, 0.5, 0), 1, Tween.TRANS_SINE)
		
		$Tween.start()
		
		yield($Tween, "tween_all_completed")
		
