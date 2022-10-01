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

	$ViewportContainer/Viewport/FollowCamera.make_current()
	
	# TODO determine random potion color and set in material/vignette shader

func intro_sequence():
	$Tween.reset_all()
	$Tween.interpolate_property($"%VignetteRect".material, "shader_param/vignette_intensity", 0.0, 0.8, 0.8, Tween.TRANS_BOUNCE)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	$Tween.reset_all()
	$Tween.interpolate_property($"%VignetteRect".material, "shader_param/vignette_intensity", 0.8, 0.0, 0.8, Tween.TRANS_BOUNCE)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	set_process_input(false)
	set_process_unhandled_input(false)
	emit_signal("intro_over")

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:  # TODO
		event = event as InputEventMouseButton
		if event.pressed:
			intro_sequence()
			get_tree().set_input_as_handled()

# When dying
func restart_level():
	$"%Viewport".remove_child($"%Viewport".get_children()[0])
	$"%Viewport".add_child(load(Game.level_list[Game.level_index]).instance())
	Events.reset()
	

func intro_over():
	yield(get_tree(), "idle_frame")
	Game.player.movement_disabled = false
