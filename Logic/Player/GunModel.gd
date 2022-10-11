extends Spatial


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
var interpolated_target: Vector3
var lerping_accel = 15.0
func _process(delta: float) -> void:
	var target_transform: Transform = get_parent().get_global_transform_interpolated()
	#target_transform.origin.y -= 2  # weapon below head
	target_transform.origin =  lerp(interpolated_target, target_transform.origin, min(lerping_accel * delta, 1.0))
	self.global_transform = target_transform
	interpolated_target = target_transform.origin  # save for next lerping step
