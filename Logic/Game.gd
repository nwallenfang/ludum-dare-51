extends Node

var player

var level_index := 0 # current level number
var level_list := [] # all levels (just the path strings)
var level # current level scene

func _ready() -> void:
	# All Levels are added here in the beginning
	level_list.append("res://Levels/FirstFloor.tscn")
	
	Events.connect("trigger_event", self, "event_triggered")

func event_triggered(event):
	event.event()

# When dying
func restart_level():
	get_tree().change_scene(level_list[level_index])

# When reaching the end
func load_next_level():
	level_index = level_index + 1
	if level_index >= level_list.size():
		print("No Levels left")
	else:
		get_tree().change_scene(level_list[level_index])
