extends Control
class_name EventBar

var number_of_events = 6

const fixed_icon_translation = 50
export var greyed_out: Color

export var question_mark_tex: Texture

func _ready() -> void:
	Events.connect("progress_update", self, "set_progress")
	Events.connect("trigger_event", self, "event_triggered")
	# TODO on new level reload fixed !!!
	init_fixed_events()


func init_fixed_events():
	# remove all the fixed icons that are currently present
	for i in $FixedIcons.get_child_count()-1:
		var possible_icon = $FixedIcons.get_child(i+1)
		if possible_icon != null:
			possible_icon.queue_free()
	
	var fixed_events = Events.fixed_events[Game.level_index]
	var amount = len(fixed_events)
	var i = 0
	for fixed_number in fixed_events:
		var fixed = fixed_events[fixed_number]
		i += 1
		var new_icon = $FixedIcons/FixedIcon.duplicate()
		$FixedIcons.add_child(new_icon)
		new_icon.name = "FixedIcon" + str(fixed_number)
		new_icon.visible = true
		new_icon.material = new_icon.material.duplicate()
		new_icon.material.set_shader_param("texture_resource", fixed.icon)
		new_icon.set("event_name", fixed.event_name)
		new_icon.rect_global_position = get_node("%EventBar/Icon" + str(fixed_number)).rect_global_position
		new_icon.rect_global_position.y = new_icon.rect_global_position.y - fixed_icon_translation
		new_icon.modulate = greyed_out

func reset():
	for i in range(1, 7):
		var icon_node: ColorRect = get_node("%EventBar/Icon" + str(i))
		icon_node.material = icon_node.material.duplicate()
		icon_node.material.set_shader_param("texture_resource", question_mark_tex)

func set_progress(seconds: float):
	var max_sec = 10.0 * number_of_events
	var normalized = seconds/max_sec
	
		
	$"%EventBar".material.set_shader_param("progress", normalized)


func event_triggered(event):
	if Events.number_triggered > 6:
		return
	
	
	var icon_node: ColorRect = get_node("%EventBar/Icon" + str(Events.number_triggered))
	icon_node.material = icon_node.material.duplicate()
	icon_node.material.set_shader_param("texture_resource", event.icon)
	$TriggerParticles.position = icon_node.rect_global_position + 0.5 * icon_node.rect_size
	$TriggerParticles.restart()
