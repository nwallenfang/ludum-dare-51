extends Control

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Game.world = self
	$ViewportContainer/Viewport/FollowCamera.make_current()

# When dying
func restart_level():
	$"%Viewport".remove_child(Game.level)
	$"%Viewport".add_child(load(Game.level_list[Game.level_index]).instance())
	Events.reset()
	
