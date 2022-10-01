extends Control
class_name EventBar

var number_of_events = 6

func _ready() -> void:
	Events.connect("progress_update", self, "set_progress")
	Events.connect("trigger_event", self, "event_triggered")

func set_progress(seconds: float):
	var max_sec = 10.0 * number_of_events
	var normalized = seconds/max_sec
	
	
	# TODO check which icons should be changed etc
	$"%EventBar".material.set_shader_param("progress", normalized)


func event_triggered(event):
	print("hi ", event)
