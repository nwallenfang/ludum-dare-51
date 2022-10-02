extends Spatial

export var shooting_distance := 10.0
export var projectile_curve_height := .2

enum STATES {IDLE, AGGRO, SHOOTING, SHOOT_COOLDOWN}
var state = STATES.IDLE

var hp := 50
func damage(amount: int):
	hp -= amount
	if hp <= 0:
		self.queue_free()

func trigger():
	state = STATES.AGGRO

var dist_to_player: float

func _physics_process(delta):
	dist_to_player = self.global_translation.distance_to(Game.player.global_translation)
	self.look_at(Game.player.global_translation, Vector3.UP)
	match state:
		STATES.IDLE:
			pass
		STATES.AGGRO:
			if dist_to_player <= shooting_distance:
				state = STATES.SHOOTING
		STATES.SHOOTING:
			make_shot()
			$ShootCooldown.start()
			state = STATES.SHOOT_COOLDOWN
		STATES.SHOOT_COOLDOWN:
			if $ShootCooldown.time_left <= 0.05:
				state = STATES.AGGRO

const PROJECTILE = preload("res://Logic/Enemies/Projectile.tscn")
func make_shot():
	var projectile = PROJECTILE.instance()
	get_tree().current_scene.add_child(projectile)
	projectile.fly($"%ShotPoint".global_translation, Game.player.global_translation, dist_to_player * projectile_curve_height, 5.0)
