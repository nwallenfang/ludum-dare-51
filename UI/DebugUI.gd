extends Control

export var time_interval_for_avg = 10.0
var fps_history = []
onready var history_size = time_interval_for_avg / $FPSUpdateTimer.wait_time
var average_fps := 0.0

func _ready() -> void:
	if OS.is_debug_build():
		set_process(true)
		$FPSUpdateTimer.start()
	else:
		set_process(false)  # could be enabled explicitly if wanted
		
	

#func _process(delta: float) -> void:

#var timer_counter = 0
var old_fps
func _on_FPSUpdateTimer_timeout() -> void:
#	timer_counter += 1
	var fps = Engine.get_frames_per_second()
#	var time_passed = $FPSUpdateTimer.wait_time * timer_counter
	
	fps_history.append(fps)
	
		
	if len(fps_history) > history_size:
		# supposed to have bad performance for large arrays but should be fine here
		old_fps = fps_history.pop_front()
		average_fps += (fps-old_fps)/history_size
	else:
		average_fps += fps/history_size


		
	$"%FPS".text = "FPS: %d" % fps
	$"%AvgFPS".text = "avg FPS: %.2f" % average_fps
