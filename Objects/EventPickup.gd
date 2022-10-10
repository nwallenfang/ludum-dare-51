extends Spatial

export var event_name: String
var event
var icon: Texture
var picked_up = false

func _ready():
	$AnimationPlayer.play("dance")
	event = Events.event_index[event_name]
	icon = event.icon

	set_process(false)
	
	$PickupCube.mesh.surface_get_material(0).set_shader_param("texture_albedo", icon)
	$PickupQuad.get_active_material(0).albedo_texture = icon
	cube_max_scale = $PickupCube.scale
	

func _on_PickupBox_area_entered(area):
	picked_up = true
	Events.event_stack.append(event)
	event.event()
	$PickupCube.visible = false
#	$PickupQuad.set_as_toplevel(true)
	$ChangeLookArea.set_deferred("monitoring", false)
	$PickupBox.set_deferred("monitoring", false)
	yield(get_tree().create_timer(1.0), "timeout")
	queue_free()


	
var cube_max_scale
var max_distance = 0.0
var start_distance = 0.10   # 10 Percent to get rid of some artifacts (not used yet)
var distance_to_player = 1000.0
func _process(delta: float) -> void:
	distance_to_player = Game.player.global_translation.distance_to(global_translation)
	
	$PickupCube.scale = distance_to_player/max_distance * cube_max_scale
	$PickupQuad.mesh.size = (max_distance - distance_to_player)/max_distance * Vector2(2.5, 2.5)
	



func _on_ChangeLookArea_area_entered(area: Area) -> void:
	set_process(true)
	$PickupQuad.visible = true
	max_distance = Game.player.global_translation.distance_to(global_translation)


func _on_ChangeLookArea_area_exited(area: Area) -> void:
	if not picked_up:
		$PickupCube.scale = cube_max_scale
		$PickupQuad.visible = false
		set_process(false)
