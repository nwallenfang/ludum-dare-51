extends Control

func _ready() -> void:
	Events.connect("trigger_event", self, "trigger_event")

func _process(delta: float) -> void:
	$CanvasLayer/FPS.text = "FPS: " + str(Engine.get_frames_per_second())

func intro_over():
	$CanvasLayer/IntroLabel.visible = false
	$CanvasLayer/EventName.visible = true
	$CanvasLayer/EventBar.visible = true

func trigger_event(event):
#	$CanvasLayer/EventName.text = event.event_name

	var text_per_frame := 3
	var all_texts := get_tree().get_nodes_in_group("walltext")
	all_texts.shuffle()
	var text_count := all_texts.size()
	
	var counter := 0
	var i := 0
	while(true):
		while(true):
			all_texts[counter].set_text(event.event_name)
			i = i + 1
			counter = counter + 1
			if counter >= text_count or i >= text_per_frame:
				i = 0
				break
		if counter >= text_count:
			break
		else:
			yield(get_tree(),"idle_frame")
	
	#get_tree().call_group("walltext", "set_text", event.event_name)
