extends Spatial

var has_key #Does the player have a key?

func _ready():
	Game.level = self
	Game.player = $Player
#	$Player.rotate_y(deg2rad(-180.0))
	has_key = false
	$Player/DrinkAnimation.queue_free()
	Game.player.show_gun()
	
	
	yield(get_tree().create_timer(3.0), "timeout")
	get_tree().call_group("tilting", "tilt")
	
	

func _physics_process(delta):
	if Game.player.global_translation.y < -30:
		Game.world.restart_level()
