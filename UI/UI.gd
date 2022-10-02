extends Control

func _ready() -> void:
	Events.connect("trigger_event", self, "trigger_event")

func _process(delta: float) -> void:
	$CanvasLayer/FPS.text = "FPS: " + str(Engine.get_frames_per_second())

func intro_over():
	$CanvasLayer/IntroLabel.visible = false
	$CanvasLayer/EventBar.visible = true

func trigger_event(event):
	# show event icon in middle of screen
	Game.text_screen_ui.set_text(event.event_name)

func reset():
	$CanvasLayer/EventBar.visible = false
	$CanvasLayer/EventBar.reset()
