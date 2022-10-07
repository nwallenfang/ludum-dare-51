extends Spatial

export var speed := .5

func _ready():
	AudioManager.play("laser_grid")
	AudioManager.set_volume("laser_grid", -80)

func _physics_process(delta):
	self.global_translation.y += speed * delta
	if Game.player.global_translation.y <= self.global_translation.y:
		Game.world.restart_level()

	
	if Game.player.global_translation.y - self.global_translation.y < 30:
		var new_db = (Game.player.global_translation.y - self.global_translation.y) / 18 * -80
		AudioManager.set_volume("laser_grid", clamp(new_db,-80, -6))
#		$MenacingStream.set_volume_db(clamp(new_db,-80, -6))
