extends ImmediateGeometry


func _ready():
	pass

func draw_line(p1: Vector3, p2: Vector3):
	begin(Mesh.PRIMITIVE_LINES)
	
	add_vertex(p1)
	add_vertex(p2)
	
	end()
	
	yield(get_tree().create_timer(0.2), "timeout")
	queue_free()
