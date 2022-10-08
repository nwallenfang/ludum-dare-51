extends Control

# gets set to true after Tutorial
var intro_sequence_should_run := false

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
signal intro_over

func _ready() -> void:
	Game.world = self
	yield(get_tree(), "idle_frame")  # had to put this there to connect Events once, bug could be fixed
	self.connect("intro_over", self, "intro_over")
	self.connect("intro_over", Events, "intro_over")
	self.connect("intro_over", Ui, "intro_over")

	if not Game.disable_music:
		AudioManager.play("ludum_dare_51_idle")

	
	Game.viewport = $EventLabelViewport
	Game.player.connect("player_got_hurt", self, "player_hurt")
	Game.player.connect("player_got_hurt", Ui.get_node("CanvasLayer/EventBar"), "update_health_bar")
	
	
	$"%VignetteRect".material.set_shader_param("vignette_intensity", 2.4)
	$"%VignetteRect".material.set_shader_param("vignette_rgb", intro_color)

export var intro_color: Color
export var potion_color: Color
var intro_running = false
func intro_sequence():
	if intro_running:
		return
	intro_running = true
	Game.text_screen_ui.set_text("thank you")
	Game.player.drink_animation()
	$Tween.reset_all()
	$Tween.interpolate_property($"%VignetteRect".material, "shader_param/vignette_intensity", null, 0.4, 0.4, Tween.TRANS_QUART)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	$"%VignetteRect".material.set_shader_param("vignette_rgb", potion_color)
	$Tween.reset_all()
	$Tween.interpolate_property($"%VignetteRect".material, "shader_param/vignette_intensity", 0.4, 1.2, 1.2, Tween.TRANS_QUART)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	$Tween.reset_all()
	$Tween.interpolate_property($"%VignetteRect".material, "shader_param/vignette_intensity", 0.8, 0.0, 2.0, Tween.TRANS_QUART)
	$Tween.start()
	
	set_process_input(false)
	set_process_unhandled_input(false)
	AudioManager.stop("ludum_dare_51_idle")
	Game.player.show_gun()
	print("INTRO OVER")
	emit_signal("intro_over")
	intro_running = false

func _input(event: InputEvent) -> void:
	if not Game.settings_open:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	if event.is_action_pressed("ui_cancel"):
		get_tree().quit() # Quits the game
		
	# not movement_disabled
	if event.is_action_pressed("shoot") and Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
		if not Game.settings_open:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
	
	if event.is_action_pressed("change_mouse_input"):
		match Input.get_mouse_mode():
			Input.MOUSE_MODE_CAPTURED:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			Input.MOUSE_MODE_VISIBLE:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if event is InputEventMouseButton:  # TODO
		event = event as InputEventMouseButton
		if event.pressed and Game.level_index != 0:
			intro_sequence()
			get_tree().set_input_as_handled()

func new_level():
	if intro_sequence_should_run:
		set_process_input(true)
		set_process_unhandled_input(true)
		Game.player.movement_disabled = true
		Game.player.connect("player_got_hurt", self, "player_hurt")
		Game.player.connect("player_got_hurt", Ui.get_node("CanvasLayer/EventBar"), "update_health_bar")

# When dying
var already_restarting = false
func restart_level():
	if already_restarting:
		return
	already_restarting = true
	
	Game.player.get_node("DeathAnimation").play("death")
	
	Events.set_process(false)
	$Tween.reset_all()
	$Tween.interpolate_property($Fader, "modulate:a", 0.0, 1.0, 1.0)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	
	$"%VignetteRect".material.set_shader_param("vignette_intensity", 0.0)
	AudioManager.stop("ludum_dare_51")

	$"%Viewport".remove_child(Game.level)
	Game.level.queue_free()
	Game.level = null
	$"%Viewport".add_child(Game.level_list[Game.level_index].instance())
	if intro_sequence_should_run:
		set_process_input(true)
		set_process_unhandled_input(true)
		if not Game.disable_music:
			AudioManager.play("ludum_dare_51_idle")
	Ui.reset()
	Events.reset()
	if Game.level_index > 0:
		Game.player.movement_disabled = true
	Game.emit_signal("viewport_texture_changed", Game.viewport)
	Game.player.connect("player_got_hurt", self, "player_hurt")
	Game.player.connect("player_got_hurt", Ui.get_node("CanvasLayer/EventBar"), "update_health_bar")
#	$Tween.reset_all()
#	$Tween.interpolate_property($Fader, "modulate:a", 0.0, 1.0, 1.0)
#	$Tween.start()
#	yield($Tween, "tween_all_completed")
	
	# vignette back to sleeping
	$"%VignetteRect".material.set_shader_param("vignette_intensity", 2.4)
	$"%VignetteRect".material.set_shader_param("vignette_rgb", intro_color)
	Game.text_screen_ui.set_text("Click to drink")
	$Tween.reset_all()
	$Tween.interpolate_property($Fader, "modulate:a", 1.0, 0.0, 0.4)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	already_restarting = false

export var hurt_color: Color
export var hurt_base_strength: float
func player_hurt(hp_left):
	var mat = $VignetteRect.material
	
	mat.set_shader_param("vignette_rgb", hurt_color)
	if hp_left == 2:
		mat.set_shader_param("vignette_intensity", 1 * hurt_base_strength)
	if hp_left == 1:
		mat.set_shader_param("vignette_intensity", 3 * hurt_base_strength)


func intro_over():
	yield(get_tree(), "idle_frame")
	Game.player.movement_disabled = false
	Game.player.gravity_multiplier = 3
	
	if not Game.disable_music:
		AudioManager.play("ludum_dare_51")

signal fade_done
func fade_out(duration):
	$Tween.reset_all()
	$Tween.interpolate_property($Fader, "modulate:a", 0.0, 1.0, duration)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	emit_signal("fade_done")
	
func fade_in(duration):
	$Tween.reset_all()
	$Tween.interpolate_property($Fader, "modulate:a", 1.0, 0.0, duration)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	emit_signal("fade_done")

