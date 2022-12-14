extends Node

export var icon: Texture
export var event_name: String

var old_env
var is_pickup

var first_time = true

func _ready() -> void:
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	old_env = Game.world.get_node("WorldEnvironment").get_environment()
	
func event():
		
	var new_env: Environment = old_env.duplicate()
	new_env.fog_depth_enabled = true
	Game.world.get_node("WorldEnvironment").set_environment(new_env)


func end_event():
	Game.world.get_node("WorldEnvironment").set_environment(old_env)
