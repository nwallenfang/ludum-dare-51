extends Spatial

var has_key #Does the player have a key?
var bridge_animation

func _ready():
	Game.level = self
	Game.player = $Player
	bridge_animation = $AnimationPlayer
	has_key = false
	
	

func _physics_process(delta):
	if Game.player.global_translation.y < -30:
		Game.world.restart_level()
		
	if Game.player.global_translation.y - $Objects/LaserGrid.global_translation.y < 3:
		Game.player.get_hurt()
