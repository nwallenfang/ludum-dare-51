extends Node

signal trigger_event(event)
signal progress_update(time)

var pickup_stack = []
var current_event

# level -> [event_number -> Event] fixed events and their timestamps
# TODO adding some events to Room 0 but this is for the TestChamber (bonus level)
# change this!!
var fixed_events = {
	0: {
#		2: 	preload("res://Logic/Events/FixedEventTest.tscn").instance(),
#		4: 	preload("res://Logic/Events/LaserGridFixedEvent.tscn").instance()
	},
	1: {

	},
	2: {
		4: 	preload("res://Logic/Events/LaserGridFixedEvent.tscn").instance()
	},
	3: {
		4: 	preload("res://Logic/Events/ArenaLaserGridFixedEvent.tscn").instance()
	},
	4: {
		3: 	preload("res://Logic/Events/FixedBridgeEvent.tscn").instance(),
	},
	5: {
	},

	6: {
		1: preload("res://Logic/Events/FixedTiltEvent.tscn").instance(),
		2: preload("res://Logic/Events/FixedTiltEvent.tscn").instance(),
		3: preload("res://Logic/Events/FixedTiltEvent.tscn").instance(),
		4: preload("res://Logic/Events/FixedTiltEvent.tscn").instance(),
		5: preload("res://Logic/Events/FixedTiltEvent.tscn").instance(),
		6: preload("res://Logic/Events/FixedTiltEvent.tscn").instance(),
		7: preload("res://Logic/Events/FixedTiltEvent.tscn").instance(),
		8: preload("res://Logic/Events/FixedTiltEvent.tscn").instance(),
		9: preload("res://Logic/Events/FixedTiltEvent.tscn").instance(),
		10: preload("res://Logic/Events/FixedTiltEvent.tscn").instance(),
		11: preload("res://Logic/Events/FixedTiltEvent.tscn").instance(),  # etc..
		12: preload("res://Logic/Events/FixedTiltEvent.tscn").instance(),
		13: preload("res://Logic/Events/FixedTiltEvent.tscn").instance(),
		14: preload("res://Logic/Events/FixedTiltEvent.tscn").instance(),
		15: preload("res://Logic/Events/FixedTiltEvent.tscn").instance(),
		16: preload("res://Logic/Events/FixedTiltEvent.tscn").instance(),
		17: preload("res://Logic/Events/FixedTiltEvent.tscn").instance(),
		18: preload("res://Logic/Events/FixedTiltEvent.tscn").instance(),
	},
}

var event_index = {
	"autofire": preload("res://Logic/Events/AutofireEvent.tscn").instance(),
	"gravity": preload("res://Logic/Events/GravityEvent.tscn").instance(),
	"disco": preload("res://Logic/Events/DiscoEvent.tscn").instance(),
	"shrink": preload("res://Logic/Events/ShrinkEvent.tscn").instance(),
	"jump": preload("res://Logic/Events/JumpEvent.tscn").instance(),
	"control": preload("res://Logic/Events/ControlEvent.tscn").instance(),
	"invincible": preload("res://Logic/Events/InvincibleEvent.tscn").instance(),
	"banana": preload("res://Logic/Events/BananaEvent.tscn").instance(),
	"explosion": preload("res://Logic/Events/ExplosionEvent.tscn").instance(),
	"akimbo": preload("res://Logic/Events/SecondGunEvent.tscn").instance(),
	"fog": preload("res://Logic/Events/FogEvent.tscn").instance(),
	"nothing": preload("res://Logic/Events/EmptyEvent.tscn").instance(),
	"fov": preload("res://Logic/Events/FovEvent.tscn").instance(),
	"heal": preload("res://Logic/Events/HealEvent.tscn").instance(),
}

var random_events_start = [
	event_index.get("autofire"),
	event_index.get("gravity"),
	event_index.get("disco"),
	event_index.get("shrink"),
	event_index.get("jump"),
	event_index.get("control"),
	event_index.get("invincible"),
	event_index.get("banana"),
	event_index.get("explosion"),
	event_index.get("akimbo"),
	event_index.get("fog"),
	event_index.get("nothing"),
	event_index.get("fov"),
]
var random_event_names_start = []
var random_event_names

func intro_over():
	set_process(true)

func reset():
	set_process(false)
	time = 0.0
	number_triggered = 0
	random_event_names = random_event_names_start.duplicate()
	for event in pickup_stack:
		event.end_event()
		
	if Game.previous_event != null:
		Game.previous_event.end_event()
		
	
func _ready():
	set_process(false)
	for event in random_events_start:
		event.name = event.event_name  # dorky line :p
		$EventScenes.add_child(event, true)
		random_event_names_start.append(event.name)
		
	random_event_names = random_event_names_start.duplicate()

var time: float
var number_triggered = 0
func _process(delta: float) -> void:
	time += delta
	if time > (number_triggered + 1) * 10.0:
		number_triggered += 1
		# trigger fixed event
		if Game.level_index in fixed_events:
			var fixed_events_for_this_lv = fixed_events[Game.level_index]
			if number_triggered in fixed_events_for_this_lv:
				var fixed_event = fixed_events_for_this_lv[number_triggered]
				emit_signal("trigger_event", fixed_event)
				if Game.level_index != 6:	# I don't want this sound every 10 secs in the bonus lv
					AudioManager.play("big_event")
			
		# always a random event
		randomize()
		if len(random_event_names) == 0:
			# reset early
			random_event_names = random_event_names_start.duplicate()
			
		var rand_index = randi() % len(random_event_names)
		var rand_name = random_event_names.pop_at(rand_index)
		emit_signal("trigger_event", $EventScenes.get_node(rand_name))

func _on_UpdateUITimer_timeout() -> void:
	emit_signal("progress_update", time)

var explosion_on_shot := false
var second_gun := false
var banana := false
var dancing := false

# event_name -> SceneTreeTimer
var timer_dict = {
	
}
func trigger_event_pickup(event, duration):
	# check if this event is already active as a pickup
	# in that case "just" reset the timer (don't know how yet)
	if event in pickup_stack:
		# find the timer belonging to this event and reset its timer
		timer_dict[event.event_name].time_left = duration
		Ui.event_pickup_reset(event, duration)
		return
	pickup_stack.push_back(event)
	event.event()
	Ui.event_picked_up(event, duration)

	var timer: SceneTreeTimer = get_tree().create_timer(duration)
	timer_dict[event.event_name] = timer
	yield(timer, "timeout")
	Ui.end_event_pickup(event)
	pickup_stack.erase(event)
	
	
	# if by chance the current (random) event equals the picked up event
	if current_event != null and current_event.event_name == event.event_name:
		return
	event.end_event()


