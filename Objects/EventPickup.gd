extends Spatial

export var event_name: String
var event
var icon: Texture

func _ready():
	$AnimationPlayer.play("dance")
	event = Events.event_index[event_name]
	icon = event.icon
	set_process(false)
	$PickupCube.mesh.surface_get_material(0).set_shader_param("texture_albedo", icon)
	cube_max_scale = $PickupCube.scale

func _on_PickupBox_area_entered(area):
	Events.event_stack.append(event)
	event.event()
	queue_free()


	
var cube_max_scale
var max_distance = 0.0
var distance_to_player = 1000.0
func _process(delta: float) -> void:
	distance_to_player = Game.player.global_translation.distance_to(global_translation)
	
	$PickupCube.scale = distance_to_player/max_distance * cube_max_scale
	$PickupQuad.mesh.size = (max_distance - distance_to_player)/max_distance * Vector2(2.5, 2.5)
	



func _on_ChangeLookArea_area_entered(area: Area) -> void:
	print("entered")
	set_process(true)
	$PickupQuad.visible = true
	max_distance = Game.player.global_translation.distance_to(global_translation)


func _on_ChangeLookArea_area_exited(area: Area) -> void:
	$PickupQuad.visible = false
	set_process(false)
