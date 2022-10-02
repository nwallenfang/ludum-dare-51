extends Spatial

var open := false

func _physics_process(delta):
	if Game.level.has_key and not open:
		if $Area.get_overlapping_areas().size() > 0:
			$AnimationPlayer.play("open")
			open = true
