extends Node

# the Game singleton
# mainly used as a global State container
# Game logic should not be placed here
# For game logic spanning across levels / runs use the World scene

signal viewport_texture_changed

var player: Spatial

var level_index := 0 # current level number
var level_list := [preload("res://Levels/Tutorial.tscn"), 
				preload("res://Levels/FloorOffice.tscn"),
				preload("res://Levels/FirstFloor.tscn"),
				preload("res://Levels/ThirdFloor.tscn"),
				preload("res://Levels/SecondFloor.tscn"),
				preload("res://Levels/Credits.tscn")] # all levels
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

func set_sensitivity(val):
	player.get_node("Head").mouse_sensitivity = val

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


func load_level(index):
	if level_index != 0:
		# going from tutorial to lv 1
		world.intro_sequence_should_run = true
	else:
		world.intro_sequence_should_run = false
	if level_index >= level_list.size():
		print("No Levels left")
		return
		
	Game.player.movement_disabled = true
	AudioManager.stop("ludum_dare_51_idle")
	AudioManager.stop("ludum_dare_51")

	yield(get_tree(), "idle_frame")

	world.fade_out(0.4)
	yield(world, "fade_done")
		
	level_index = index
	var new_level = level_list[level_index].instance()
	world.get_node("ViewportContainer/Viewport").remove_child(Game.level)
	Game.level.queue_free()
	Game.level = null
	world.get_node("ViewportContainer/Viewport").add_child(new_level)
	Game.level = new_level
	Events.reset()
	
	Ui.reset()
	
	AudioManager.play("ludum_dare_51_idle")
	
	if level_index < number_of_levels - 1:
		text_screen_ui.set_text("Click to drink")
	world.new_level()	
		
	emit_signal("viewport_texture_changed", viewport)	
	world.fade_in(0.4)
	yield(world, "fade_done")

# When reaching the end
func load_next_level():
	Game.player.movement_disabled = true
	AudioManager.stop("ludum_dare_51_idle")
	AudioManager.stop("ludum_dare_51")

	yield(get_tree(), "idle_frame")

	world.fade_out(0.4)
	yield(world, "fade_done")
	

		
	level_index = level_index + 1
	
	if level_index != 0:
		# going from tutorial to lv 1
		world.intro_sequence_should_run = true
	else:
		world.intro_sequence_should_run = false
	if level_index >= level_list.size():
		print("No Levels left")
	else:
		var new_level = level_list[level_index].instance()
		world.get_node("ViewportContainer/Viewport").remove_child(Game.level)
		Game.level.queue_free()
		Game.level = null
		world.get_node("ViewportContainer/Viewport").add_child(new_level)
		Game.level = new_level
		Events.reset()
		
		Ui.reset()
		
		AudioManager.play("ludum_dare_51_idle")
		
		if level_index < number_of_levels - 1:
			text_screen_ui.set_text("Click to drink")
	world.new_level()	
		
	emit_signal("viewport_texture_changed", viewport)	
	world.fade_in(0.4)
	yield(world, "fade_done")
	

