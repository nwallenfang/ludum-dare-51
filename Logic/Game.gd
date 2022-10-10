extends Node

# the Game singleton
# mainly used as a global State container
# Game logic should not be placed here
# For game logic spanning across levels / runs use the World scene

signal viewport_texture_changed

signal new_player_set
var player: Spatial setget set_player

var level_index := 0 # current level number
var level_list := [
	preload("res://Levels/Prototyping/TestChamber.tscn"), 
	preload("res://Levels/Tutorial.tscn"), 
	preload("res://Levels/FloorOffice.tscn"),
	preload("res://Levels/FirstFloor.tscn"),
	preload("res://Levels/ThirdFloor.tscn"),
	preload("res://Levels/SecondFloor.tscn"),
	preload("res://Levels/Credits.tscn")
] # all levels
var number_of_levels = len(level_list)
var level # current level scene
var world
var player_camera: Camera
var previous_event

var disable_music = false
var skip_intro = false

# this is the Event Text 2DViewport this is NOT the 3D root viewport
var viewport: Viewport setget set_2d_viewport
var viewport_material: SpatialMaterial

var text_screen_ui

var settings_open = false

export var min_sensitivity := 0.001
export var max_sensitivity := 0.015

func _ready() -> void:
	Events.connect("trigger_event", self, "event_triggered")

func set_player(playerr: Spatial):
	player = playerr
	emit_signal("new_player_set")

func set_sensitivity(val):
	player.get_node("Head").mouse_sensitivity = val

func set_2d_viewport(viewport_t):
	viewport = viewport_t
	emit_signal("viewport_texture_changed", viewport)

func event_triggered(event):
	
	if !Events.stacking_events:
		# Stop the previous non-fixed event and start the next one.
		# If we are working on a fixed event (no end method) don't stop anything
		if event.has_method("end_event") and previous_event != null:
			previous_event.end_event()
			
		event.event()
		
		if event.has_method("end_event"):
			previous_event = event
	else:
		# If it is a non-fixed event, add it to the event stack
		if event.has_method("end_event"):
			Events.event_stack.append(event)
			
		event.event()



	

