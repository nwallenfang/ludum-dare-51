extends Node

signal viewport_texture_changed

var player: Spatial

var level_index := 0 # current level number
var level_list := [preload("res://Levels/Tutorial.tscn"), 
				preload("res://Levels/FirstFloor.tscn"),
				preload("res://Levels/SecondFloor.tscn"),
				preload("res://Levels/ThirdFloor.tscn")] # all levels
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

var settings_open = false

export var min_sensitivity := 0.001
export var max_sensitivity := 0.015

func _ready() -> void:
	Events.connect("trigger_event", self, "event_triggered")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("jump_to_next_level"):
		print("jump")
		Game.load_next_level()

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


# When reaching the end
func load_next_level():
	world.fade_out(0.4)
	yield(world, "fade_done")
	world.get_node("IdleStream").stop()
	world.get_node("Level1Stream").stop()
	yield(get_tree(), "idle_frame")
	
	if level_index == 0:
		# going from tutorial to lv 1
		world.intro_sequence_should_run = true
		
	level_index = level_index + 1
	if level_index >= level_list.size():
		print("No Levels left")
	else:
		# TODO fix lag spike
		var new_level = level_list[level_index].instance()
		world.get_node("ViewportContainer/Viewport").remove_child(Game.level)
		Game.level.queue_free()
		Game.level = null
		world.get_node("ViewportContainer/Viewport").add_child(new_level)
		Game.level = new_level
		Events.reset()
		
		Ui.reset()
		
		world.get_node("Level1Stream").stop()
		world.get_node("IdleStream").play(0.2)
		
		
	emit_signal("viewport_texture_changed", viewport)	
	world.fade_in(0.4)
	yield(world, "fade_done")
	
	world.new_level()

