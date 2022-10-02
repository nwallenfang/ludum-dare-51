extends Node

signal viewport_texture_changed

var player

var level_index := 0 # current level number
var level_list := [] # all levels (just the path strings)
var level # current level scene
var world
var player_camera: Camera
var previous_event

var disable_music = false
var skip_intro = false

#var viewport_texture: ViewportTexture setget set_viewport_texture
var viewport: Viewport setget set_2d_viewport
var viewport_material: SpatialMaterial

var text_screen_ui



func _ready() -> void:
	# All Levels are added here in the beginning
	level_list.append("res://Levels/Tutorial.tscn")
	level_list.append("res://Levels/FirstFloor.tscn")
	
	Events.connect("trigger_event", self, "event_triggered")

func set_2d_viewport(viewport_t):
	viewport = viewport_t
	emit_signal("viewport_texture_changed", viewport)

func event_triggered(event):
	# Stop the previous non-fixed event and start the next one.
	# If we are working on a fixed event (no end method) don't stop anything
	if event.has_method("end_event") and previous_event != null:
		previous_event.end_event()
		
	event.event()
	
	if event.has_method("end_event"):
		previous_event = event


# When reaching the end
func load_next_level():
	level_index = level_index + 1
	if level_index >= level_list.size():
		print("No Levels left")
	else:
		get_tree().change_scene(level_list[level_index])
