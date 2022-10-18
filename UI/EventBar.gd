extends Control
class_name EventBar

var number_of_events = 6

const fixed_icon_translation = 80
export var greyed_out: Color

export var question_mark_tex: Texture

export var full_health_color: Color
export var partial_health_color: Color
export var low_health_color: Color

func _ready() -> void:
	Events.connect("progress_update", self, "set_progress")
	Events.connect("trigger_event", self, "event_triggered")

	init_fixed_events()
	init_pickup_events()


func update_health_bar(hp):
	$GetHitBlink.play("get_hit")
	if hp == 3:
		$Background.material.set_shader_param("mod_color", full_health_color)
	if hp == 2:
		$Background.material.set_shader_param("mod_color", partial_health_color)
	if hp == 1:
		$Background.material.set_shader_param("mod_color", low_health_color)

func init_fixed_events():
	# remove all the fixed icons that are currently present
	for n in $FixedIcons.get_children():
		if n.name != "FixedIcon":
			$FixedIcons.remove_child(n)
			n.queue_free()
#	for i in $FixedIcons.get_child_count()-1:
#		var possible_icon = $FixedIcons.get_child(i+1)
#		if possible_icon != null:
#			possible_icon.queue_free()

	if Game.level_index == Game.number_of_levels - 1:
		# we're in credit level
		return
	if not Game.level_index in Events.fixed_events:
		# no fixed events for this
		return
	var fixed_events = Events.fixed_events[Game.level_index]
	var amount = len(fixed_events)
	var i = 0
	for fixed_number in fixed_events:
		var fixed = fixed_events[fixed_number]
		i += 1
		var new_icon = $FixedIcons/FixedIcon.duplicate()
		new_icon.name = "FixedIcon" + str(fixed_number)
		$FixedIcons.add_child(new_icon, true)

		new_icon.visible = true
		new_icon.material = new_icon.material.duplicate()
		new_icon.material.set_shader_param("texture_resource", fixed.icon)
		new_icon.set("event_name", fixed.event_name)
		new_icon.rect_global_position = get_node("%EventBar/Icon" + str(fixed_number)).rect_global_position
		new_icon.rect_global_position.y = new_icon.rect_global_position.y - fixed_icon_translation
		new_icon.rect_global_position.x = new_icon.rect_global_position.x - 0.2 * fixed_icon_translation
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
	# if there is a fixed event for this, it should modulate to fully white
	# later animate it as well with a looping tween probably
	if Events.number_triggered > 6:
		return
	if $FixedIcons.has_node("FixedIcon" + str(Events.number_triggered)):
		var fixed_icon = $FixedIcons.get_node("FixedIcon" + str(Events.number_triggered))
		fixed_icon.modulate = Color.white
	
	var icon_node: ColorRect = get_node("%EventBar/Icon" + str(Events.number_triggered))
	icon_node.material = icon_node.material.duplicate()
	icon_node.material.set_shader_param("texture_resource", event.icon)
	$TriggerParticles.position = icon_node.rect_global_position + 0.5 * icon_node.rect_size
	$TriggerParticles.restart()


var offset = Vector2(0.0, 0.0)
func _process(delta: float) -> void:
	var forward_direction = Game.player.global_transform.basis.z
	var look_direction_xz = Vector2(forward_direction.x, forward_direction.z)

	offset += delta * Vector2(Game.player.velocity.x, Game.player.velocity.z).rotated(deg2rad(90) + look_direction_xz.angle())
	$Background.material.set_shader_param("direction", offset)


onready var icon_positions = []  # array of vector 2s
onready var index_to_event = {}  # key: position (1 to 3 for now), value: event
func init_pickup_events():  # called from _ready
	for event_icon in $Pickups.get_children():
		if event_icon is ColorRect:
			icon_positions.append(event_icon.rect_global_position)


func new_event_has_place():
	return true  # not used yet

func add_new_event_pickup(event):
	# TODO play Particles as well (TriggerParticles
	# find empty spot
	var empty_index
	for i in range(3):
		if not (i+1) in index_to_event:
			empty_index = i+1
			break
	if empty_index == null:
		# no place for this event 
		return

	index_to_event[empty_index] = event
	var icon_node = get_node("Pickups/EventPickupIcon" + str(empty_index))
	var circle_node = icon_node.get_node("Circle")
	icon_node.visible = true
	icon_node.material.set_shader_param("icon", event.icon)
	
	var tween = get_tree().create_tween()
	circle_node.material.set_shader_param("filling", 1.0)
	tween.tween_property(circle_node.material, "shader_param/filling", 0.0, 10.0)
	tween.play()
	
func remove_old_event_pickup(event):
	# find index
	var index
	for test in index_to_event:
		if index_to_event[test] == event:
			index = test
			break
			
	var icon_node = get_node("Pickups/EventPickupIcon" + str(index))
	if icon_node == null:
		printerr("Event ", event.name, " with index ", str(index), " does not exist!")
		return
	
	var circle_node = icon_node.get_node("Circle")
	circle_node.material.set_shader_param("filling", 1.0)
	icon_node.visible = false
	index_to_event.erase(index)
	
