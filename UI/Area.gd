extends Area


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


func put_mouse_event(mouse_position):
	get_parent().get_parent().handle_mouse(mouse_position, true)
