extends Control

func _ready() -> void:
	Events.connect("trigger_event", self, "trigger_event")

func _process(delta: float) -> void:
		$CanvasLayer/FPS.text = "FPS: " + str(Engine.get_frames_per_second())


func trigger_event(event):
	$CanvasLayer/EventName.text = event.event_name