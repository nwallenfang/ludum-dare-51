extends Node


var level_index = 1


func _ready() -> void:
	Events.connect("trigger_event", self, "event_triggered")


func event_triggered():
	print("event")
