extends Node

signal trigger_event(event)
signal progress_update(time)


# level -> [event_number -> Event] fixed events and their timestamps
var fixed_events = {
	0: {
		2: 	preload("res://Logic/Events/FixedEventTest.tscn").instance()
	}
}

var random_events = [
	preload("res://Logic/Events/GrowEvent.tscn").instance()
]


func reset():
	time = 0.0
	number_triggered = 0
	

var time: float
var number_triggered = 0
func _process(delta: float) -> void:
	time += delta
	if time > (number_triggered + 1) * 10.0:
		number_triggered += 1
		# trigger event
		var fixed_events_for_this_lv = fixed_events[Game.level_index]
		if number_triggered in fixed_events_for_this_lv:
			var fixed_event = fixed_events_for_this_lv[number_triggered]
			emit_signal("trigger_event", fixed_event)
			
		# always a random event
		var rand_index = randi() % len(random_events)
		emit_signal("trigger_event", random_events[rand_index])


func _on_UpdateUITimer_timeout() -> void:
	emit_signal("progress_update", time)
