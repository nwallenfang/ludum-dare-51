extends Control

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
signal intro_over

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Game.world = self
	yield(get_tree(), "idle_frame")
	self.connect("intro_over", self, "intro_over")
	self.connect("intro_over", Events, "intro_over")
	self.connect("intro_over", Ui, "intro_over")
	if Game.skip_intro:
		emit_signal("intro_over")
	if not Game.disable_music:
		$IdleStream.play()

	$ViewportContainer/Viewport/FollowCamera.make_current()
	
	
	Game.viewport = $Viewport2D
	
	Game.player.connect("player_got_hurt", self, "player_hurt")
	
	$"%VignetteRect".material.set_shader_param("vignette_intensity", 2.4)
	$"%VignetteRect".material.set_shader_param("vignette_rgb", intro_color)

export var intro_color: Color
export var potion_color: Color
func intro_sequence():
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
	$IdleStream.stop()
	emit_signal("intro_over")

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:  # TODO
		event = event as InputEventMouseButton
		if event.pressed:
			intro_sequence()
			get_tree().set_input_as_handled()

# When dying
var already_restarting = false
func restart_level():
	if already_restarting:
		return
	already_restarting = true
	$Tween.reset_all()
	$Tween.interpolate_property($Fader, "modulate:a", 0.0, 1.0, 1.0)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	
	$"%VignetteRect".material.set_shader_param("vignette_intensity", 0.0)
	$Level1Stream.stop()
	if not Game.disable_music:
		$IdleStream.play()
	$"%Viewport".remove_child(Game.level)
	$"%Viewport".add_child(load(Game.level_list[Game.level_index]).instance())
	set_process_input(true)
	set_process_unhandled_input(true)
	Ui.reset()
	Events.reset()

	$Tween.reset_all()
	$Tween.interpolate_property($Fader, "modulate:a", 0.0, 1.0, 1.0)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	
	# vignette back to sleeping
	$"%VignetteRect".material.set_shader_param("vignette_intensity", 2.4)
	$"%VignetteRect".material.set_shader_param("vignette_rgb", intro_color)
	
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
	
	if not Game.disable_music:
		$Level1Stream.play()
