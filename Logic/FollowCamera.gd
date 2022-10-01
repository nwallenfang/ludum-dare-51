extends Camera

var camera_accel = 45

func _process(delta: float) -> void:
	if Engine.get_frames_per_second() > Engine.get_physics_frames():
		$"%FollowCamera".global_transform = $"%FollowCamera".global_transform.interpolate_with(Game.player_camera.global_transform, camera_accel * delta)
	else:
		$"%FollowCamera".global_transform = Game.player_camera.global_transform
