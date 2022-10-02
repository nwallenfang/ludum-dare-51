extends Spatial

export var door_needs_no_key := false

var open := false

func _physics_process(delta):
	if (Game.level.has_key or door_needs_no_key) and not open:
		if $Area.get_overlapping_areas().size() > 0:
			$AnimationPlayer.play("open")
			open = true
