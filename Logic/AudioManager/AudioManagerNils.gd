extends Node

export var sound_directoy = "res://Assets/Sound"

var num_players = 32
var bus = "master"

var available = []  # The available players.
var queue = []  # The queue of sounds to play.
var playing = [] # The players that are currently active, indexed by the sound name

var sound_streams = {}
var sound_config

var MANAGED_SOUND_SCENE = preload("res://Logic/AudioManager/ManagedSound.tscn")
		

func _ready():
	# Create an AudioPlayer for each sound in the resources
	var dir = Directory.new()
	if dir.open(sound_directoy) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".ogg"):

				sound_streams[file_name] = load("res://Assets/Sound/" + file_name)
				
				var p = MANAGED_SOUND_SCENE.instance()
				p.file_name = file_name
				p.stream = load("res://Assets/Sound/" + file_name)
				
				add_child(p.player, true)
				
				available.append(p)
			file_name = dir.get_next()
	else:
		print("An error encountered loading the sounds")

	
	
#func play(file_name: String):
#	if !file_name.ends_with(".ogg"):
#		file_name += ".ogg"
#	queue.append(file_name)
#
#func stop(file_name: String):
#	if !file_name.ends_with(".ogg"):
#		file_name += ".ogg"
#
#	for stream_tuple in playing:
#		print(stream_tuple.file_name)
#		if stream_tuple.file_name == file_name:
#			stream_tuple.player.stop()
#
#func set_volume(file_name, volume):
#	if !file_name.ends_with(".ogg"):
#		file_name += ".ogg"
#
#	for stream_tuple in playing:
#		print(stream_tuple.file_name)
#		if stream_tuple.file_name == file_name:
#			stream_tuple.player.set_volume_db(volume)
#
#func _process(delta):
#	# Play a queued sound if any players are available.
#	print(available.size())
#	if not queue.empty() and not available.empty():
#		var file_name = queue.pop_front()
#		# Reset all player variables
#		available[0].player.set_volume_db(0)
#		available[0].player.stream = sound_streams[file_name]
#		available[0].file_name = file_name
#		available[0].player.play()
#		playing.append(available.pop_front())
