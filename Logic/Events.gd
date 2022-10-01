extends Node

signal trigger_event
signal progress_update(time)

var event_bar: Node
var number_triggered = 0

# level -> fixed events and their timestamps
var fixed_events = {
	1: null
}


var time: float
func _process(delta: float) -> void:
	time += delta
	if time > (number_triggered + 1) * 10.0:
		emit_signal("trigger_event")
		number_triggered += 1


func _on_UpdateUITimer_timeout() -> void:
	emit_signal("progress_update", time)
