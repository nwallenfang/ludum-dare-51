extends Spatial

func _physics_process(delta):
	if Events.dancing:
		$"%Lights".visible = true
		$"%Pivot".rotation_degrees.y = 90 + 110 * sin(Time.get_ticks_msec() * .003)
		$"%PivotUpDown".rotation_degrees.z = clamp(30 * cos(Time.get_ticks_msec() * 1.5 * .003), -30, 40)
		$"%Lights".rotation_degrees.z = 180 * cos(Time.get_ticks_msec() * 1.2 * .004)
	else:
		$"%Lights".visible = false
		if is_instance_valid(Game.player):
			var player_global = Game.player.global_translation + Vector3.UP * 1.5
			var player_2d_global = Game.player.global_translation - Game.player.global_translation.project(Vector3.UP)
			
			$"%Pivot".look_at(player_2d_global + Vector3.UP * $"%Pivot".global_translation.y, Vector3.UP)
			
			$"%UpDownAngle".look_at(player_global, Vector3.RIGHT)
			#print($"%UpDownAngle".rotation_degrees)
			$"%PivotUpDown".rotation_degrees.z = clamp(-$"%UpDownAngle".rotation_degrees.x, -30, 35)
