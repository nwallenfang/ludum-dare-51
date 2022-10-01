extends Spatial

var has_key #Does the player have a key?

func _ready():
	Game.level = self
	Game.player = $Player
	has_key = false
	
	

func _physics_process(delta):
	if Game.player.global_translation.y < -30:
		Game.world.restart_level()
