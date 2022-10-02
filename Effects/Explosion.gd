extends Spatial

func _ready():
	yield(get_tree().create_timer(.1),"timeout")
	$Area.queue_free()
	yield(get_tree().create_timer(1),"timeout")
