extends Spatial

export var event_name: String
var event
var icon: Texture

func _ready():
	event = Events.event_index[event_name]
	icon = event.icon
	
	$HoverPickup.mesh.surface_get_material(0).set_shader_param("texture_albedo", icon)

func _on_PickupBox_area_entered(area):
	Events.event_stack.append(event)
	event.event()
