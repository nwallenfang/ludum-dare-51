extends Spatial

export var id := 0


func _on_Area_area_entered(area):
	get_tree().call_group("trigger" + str(id), "trigger")
	queue_free()
