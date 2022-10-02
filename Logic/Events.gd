extends Node

signal trigger_event(event)
signal progress_update(time)


# level -> [event_number -> Event] fixed events and their timestamps
var fixed_events = {
	0: {
		2: 	preload("res://Logic/Events/FixedEventTest.tscn").instance(),
		1: 	preload("res://Logic/Events/LaserGridFixedEvent.tscn").instance()
	},
	1: {
		1: 	preload("res://Logic/Events/LaserGridFixedEvent.tscn").instance()
	},
	2: {
		2: 	preload("res://Logic/Events/FixedBridgeEvent.tscn").instance(),
	}
}

var random_events_start = [
	preload("res://Logic/Events/GravityEvent.tscn").instance(),
	preload("res://Logic/Events/ShrinkEvent.tscn").instance(),
	preload("res://Logic/Events/JumpEvent.tscn").instance(),
	preload("res://Logic/Events/ControlEvent.tscn").instance(),
	preload("res://Logic/Events/InvincibleEvent.tscn").instance(),
	preload("res://Logic/Events/BananaEvent.tscn").instance(),
	preload("res://Logic/Events/ExplosionEvent.tscn").instance()
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
	
	
func _ready():
	set_process(false)
	for event in random_events_start:
		$EventScenes.add_child(event)
		random_event_names_start.append(event.name)
		
	random_event_names = random_event_names_start.duplicate()

var time: float
var number_triggered = 0
func _process(delta: float) -> void:
	time += delta
	if time > (number_triggered + 1) * 10.0:
		number_triggered += 1
		# trigger event
		if Game.level_index in fixed_events:
			var fixed_events_for_this_lv = fixed_events[Game.level_index]
			if number_triggered in fixed_events_for_this_lv:
				var fixed_event = fixed_events_for_this_lv[number_triggered]
				emit_signal("trigger_event", fixed_event)
				$WarningStream.play()
			
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
