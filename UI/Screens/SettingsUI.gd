extends Control



func _ready() -> void:
	$Panel/VBoxContainer/HBoxContainer3.visible = OS.is_debug_build() 


func determine_git_hash() -> String:
	var commit_id_output = [] 
	var project_dir = ProjectSettings.globalize_path("res://")
	var args = ["-C", project_dir, "log", "--pretty=format:'%h'", "-n 1"]
#	var args_test = ["-C",  project_dir, "status"]

	var exit_code = OS.execute("git", args, true, commit_id_output, true)
	
	if exit_code != 0:
		return "git-error"
	else:
		return commit_id_output[0]

func save_benchmark(metadata: String):
	var benchmark := File.new()
	benchmark.open("res://benchmarks.txt", File.READ_WRITE)
	
	var time_string = Time.get_date_string_from_system() + " " + Time.get_time_string_from_system()
	var commit_hash = determine_git_hash()
	var level = "level" + str(Game.level_index)
	var avg_fps = "%.2f" % Ui.get_avg_fps()
	
	benchmark.seek_end()
	benchmark.store_line("[%s, %s], %s, info: %s, fps: %s" % [time_string, commit_hash, level, metadata, avg_fps])
	benchmark.close()


func _on_SaveFPSButton_pressed() -> void:
	save_benchmark($"%Metadata".text)


onready var metadata_default_text = $"%Metadata".text
func _on_Metadata_focus_entered() -> void:
	if $"%Metadata".text == metadata_default_text:
		$"%Metadata".text = ""

func _on_SensitivitySlider_value_changed(value: float) -> void:
	Game.set_sensitivity(Game.min_sensitivity + value * (Game.max_sensitivity - Game.min_sensitivity))


func _on_SoundSlider_value_changed(value: float) -> void:
	print(AudioServer.get_bus_name(0))
	AudioServer.set_bus_volume_db(0, linear2db(value))

func hide_settings():
	Game.settings_open = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	self.visible = false


func _on_Button_pressed():
	hide_settings()
