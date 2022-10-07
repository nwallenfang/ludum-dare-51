extends Control

func _ready() -> void:
	Events.connect("trigger_event", self, "trigger_event")
	$IconGrow.play("RESET")



func show_settings():
	Game.settings_open = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$CanvasLayer/Settings.visible = true
	
func hide_settings():
	Game.settings_open = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$CanvasLayer/Settings.visible = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("open_settings"):
		if $CanvasLayer/Settings.visible:
			hide_settings()
		else:
			show_settings()

	$CanvasLayer/FPS.text = "FPS: " + str(Engine.get_frames_per_second())

func intro_over():
	$CanvasLayer/IntroLabel.visible = false
	$CanvasLayer/EventBar.visible = true

func trigger_event(event):
	# show event icon in middle of screen
	Game.text_screen_ui.set_text(event.event_name)
	$CanvasLayer/EventIcon.material.set_shader_param("texture_resource", event.icon)
	$IconGrow.play("grow")	

func reset():
	$CanvasLayer/EventBar.visible = false
	$CanvasLayer/EventBar.reset()
	$CanvasLayer/EventBar.update_health_bar(3)
	$CanvasLayer/EventBar.init_fixed_events()


func _on_Button_pressed() -> void:
	hide_settings()


func to_credits():
	$"%Crosshair".visible = false
	$CanvasLayer/SettingsIcon.visible = false
	$CanvasLayer/FLabel.visible = false
	$CanvasLayer/CreditsUI.visible = true

func _on_SensitivitySlider_value_changed(value: float) -> void:
	Game.set_sensitivity(Game.min_sensitivity + value * (Game.max_sensitivity - Game.min_sensitivity))


func _on_SoundSlider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, linear2db(value))
