extends Camera

var head: Spatial

func _ready() -> void:
	Game.connect("new_player_set", self, "new_player_set")
	# get a reference to player head
	yield(get_tree(), "idle_frame")
	head = Game.player.get_node("Head")

func new_player_set():
	head = Game.player.get_node("Head")

var interpolated_target: Vector3
var lerping_accel = 20.0
func _process(delta: float) -> void:
	if is_instance_valid(head):
		var target_transform: Transform = head.get_global_transform_interpolated()
		target_transform.origin =  lerp(interpolated_target, target_transform.origin, min(lerping_accel * delta, 1.0))
		self.global_transform = target_transform
		interpolated_target = target_transform.origin
