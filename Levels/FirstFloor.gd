extends Spatial

func _ready():
	Game.level = self
	Game.player = $Player

func _physics_process(delta):
	if Game.player.global_translation.y < -30:
		Game.restart_level()
