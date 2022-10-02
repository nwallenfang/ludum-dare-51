extends Spatial


export(NodePath) var cam_path := NodePath("Camera")
onready var cam: Camera = get_node(cam_path)

export var mouse_sensitivity := 5.0
export var y_limit := 90.0
var mouse_axis := Vector2()
var rot := Vector3()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mouse_sensitivity = mouse_sensitivity / 1000
	y_limit = deg2rad(y_limit)
	Game.player_camera = $Camera
	
	rot.y = deg2rad(180.0)


# Called when there is an input event
func _input(event: InputEvent) -> void:
	# Mouse look (only if the mouse is captured).
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		mouse_axis = event.relative
		camera_rotation()


func camera_rotation() -> void:
	if Game.player.inverted_controls:
		# Horizontal mouse look.
		rot.y += mouse_axis.x * mouse_sensitivity
		# Vertical mouse look.
		rot.x = clamp(rot.x + mouse_axis.y * mouse_sensitivity, -y_limit, y_limit)
	else:
		# Horizontal mouse look.
		rot.y -= mouse_axis.x * mouse_sensitivity
		# Vertical mouse look.
		rot.x = clamp(rot.x - mouse_axis.y * mouse_sensitivity, -y_limit, y_limit)
	
	get_owner().rotation.y = rot.y
	rotation.x = rot.x
