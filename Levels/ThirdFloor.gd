extends Spatial

var has_key #Does the player have a key?
var stage_0_done_animation: AnimationPlayer
var has_played_stage_0 = false

func _ready():
	Game.level = self
	Game.player = $Player
	has_key = false
	stage_0_done_animation = $Stage0Done
	
func _physics_process(delta):
	if Game.player.global_translation.y < -30:
		Game.world.restart_level()
		
	# Kill enemies if they drop under the map
	for enemy in get_tree().get_nodes_in_group("trigger10"):
		if enemy.global_translation.y < -30:
			enemy.queue_free()
	
	if get_tree().get_nodes_in_group("trigger10").size() == 0 and !has_played_stage_0:
		stage_0_done_animation.play("stage0done")
		has_played_stage_0 = true
		
	if get_tree().get_nodes_in_group("trigger11").size() == 0 and !has_key:
		$Objects/KeyPickup.visible = true
