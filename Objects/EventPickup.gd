extends Spatial

export var event_name: String
var event
var icon: Texture
var picked_up = false

onready var cube_max_scale = $PickupCube.scale
onready var cube_min_scale = $PickupCube.scale * 0.5
onready var quad_max_scale = $PickupQuad.mesh.size

func _ready():
	$AnimationPlayer.play("dance")
	event = Events.event_index[event_name]
	icon = event.icon

	set_process(false)
	$PickupCube.get_active_material(0).set_shader_param("texture_albedo", icon)
	$PickupQuad.get_active_material(0).set_shader_param("texture_albedo", icon)


func _on_PickupBox_area_entered(area):
	picked_up = true
	Events.event_stack.append(event)
	event.event()
	AudioManager.play("event_pickup")
	$PickupCube.visible = false
	set_process(false)
	$ChangeLookArea.set_deferred("monitoring", false)
	$PickupBox.set_deferred("monitoring", false)
	yield(get_tree().create_timer(.4), "timeout")
	$Tween.reset_all()
	$Tween.interpolate_property($PickupQuad.mesh, "size", $PickupQuad.mesh.size, Vector2(0.0, 0.0), 0.7)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	queue_free()



var start_distance = 0.10   # 10 Percent to get rid of some artifacts
func size_percentage(distance, max_distance):  # for the quad for now
	var dist_percent = 1.0 - distance/max_distance
#	print(dist_percent)
	if dist_percent < start_distance:
		return 0
	return (dist_percent - start_distance) * 1/(1.0 - start_distance)


var max_distance = 0.0

var distance_to_player = 1000.0
func _process(delta: float) -> void:
	if not picked_up:
		distance_to_player = Game.player.global_translation.distance_to(global_translation)
		
		$PickupCube.scale = cube_min_scale + distance_to_player/max_distance * (cube_max_scale - cube_min_scale)
		$PickupQuad.mesh.size = size_percentage(distance_to_player, max_distance) * quad_max_scale
	



func _on_ChangeLookArea_area_entered(area: Area) -> void:
	if not picked_up:
		set_process(true)
		$PickupQuad.visible = true
		max_distance = Game.player.global_translation.distance_to(global_translation)


func _on_ChangeLookArea_area_exited(area: Area) -> void:
	if not picked_up:
		$PickupCube.scale = cube_max_scale
		$PickupQuad.visible = false
		set_process(false)
