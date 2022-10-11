extends Control

func _ready() -> void:
	Events.connect("trigger_event", self, "trigger_event")
	if OS.is_debug_build():
		$CanvasLayer/DebugUI.visible = true
	$IconGrow.play("RESET")


func show_settings():
	Game.settings_open = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$CanvasLayer/SettingsUI.visible = true
	
func hide_settings():
	Game.settings_open = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$CanvasLayer/SettingsUI.visible = false

var photo_mode = false
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("open_settings"):
		if $CanvasLayer/SettingsUI.visible:
			hide_settings()
		else:
			show_settings()
	if Input.is_action_just_pressed("photo_mode"):
		photo_mode = not photo_mode
		$CanvasLayer/CenterContainer/Crosshair.visible = photo_mode
		$CanvasLayer/DebugUI.visible = photo_mode
		$CanvasLayer/SettingsIcon.visible = photo_mode
		$CanvasLayer/FLabel.visible = photo_mode

func intro_over():
	$CanvasLayer/IntroLabel.visible = false
	$CanvasLayer/EventBar.visible = true

func trigger_event(event):
	# show event icon in middle of screen
	Game.text_screen_ui.set_text(event.event_name)
	$CanvasLayer/EventIcon.material.set_shader_param("texture_resource", event.icon)
	$IconGrow.play("grow")	

func show_level_select():
	Game.settings_open = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$CanvasLayer/LevelPanelUI.visible = true
	
func hide_level_select():
	Game.settings_open = false
	$CanvasLayer/LevelPanelUI.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func reset():
	$CanvasLayer/EventBar.visible = false
	$CanvasLayer/EventBar.reset()
	$CanvasLayer/EventBar.update_health_bar(3)
	$CanvasLayer/EventBar.init_fixed_events()
	hide_level_select()


func _on_Button_pressed() -> void:
	hide_settings()

func get_avg_fps() -> float:
	return $CanvasLayer/DebugUI.average_fps

func to_credits():
	$"%Crosshair".visible = false
	$CanvasLayer/SettingsIcon.visible = false
	$CanvasLayer/FLabel.visible = false
	$CanvasLayer/CreditsUI.visible = true

func _on_FPSUpdateTimer_timeout() -> void:
	pass # Replace with function body.
