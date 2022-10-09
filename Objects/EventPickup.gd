extends Spatial

export var event_name: String
var event
var icon := "res://Assets/Sprites/banana.png"

func _ready():
	event = Events.event_index[event_name]
	
	$HoverPickup.mesh.surface_get_material(0).set_shader_param("event_icon", load(icon))

func _on_PickupBox_area_entered(area):
	Events.event_stack.append(event)
	event.event()
