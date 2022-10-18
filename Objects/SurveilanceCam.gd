extends Spatial

func _physics_process(delta):
	if is_instance_valid(Game.player):
		var player_global = Game.player.global_translation + Vector3.UP * 1.5
		var player_2d_global = Game.player.global_translation - Game.player.global_translation.project(Vector3.UP)
		
		$"%Pivot".look_at(player_2d_global + Vector3.UP * $"%Pivot".global_translation.y, Vector3.UP)
		
		$"%UpDownAngle".look_at(player_global, Vector3.RIGHT)
		#print($"%UpDownAngle".rotation_degrees)
		$"%PivotUpDown".rotation_degrees.z = clamp(-$"%UpDownAngle".rotation_degrees.x, -30, 30)
