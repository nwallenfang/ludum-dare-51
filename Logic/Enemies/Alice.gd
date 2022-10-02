extends Spatial

export var shooting_distance := 20.0
export var projectile_curve_height := .2

enum STATES {IDLE, AGGRO, SHOOTING, SHOOT_COOLDOWN, DEATH}
var state = STATES.IDLE

var hp := 50
func damage(amount: int):
	hp -= amount
	hurt_visuals()
	if hp <= 0:
		if state != STATES.DEATH:
			death_animation()
			state = STATES.DEATH

func trigger():
	state = STATES.AGGRO

var dist_to_player: float

func _physics_process(delta):
	dist_to_player = self.global_translation.distance_to(Game.player.global_translation)
	self.look_at(Game.player.global_translation, Vector3.UP)
	match state:
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
	projectile.global_translation = $"%ShotPoint".global_translation
	projectile.fly($"%ShotPoint".global_translation, Game.player.global_translation, dist_to_player * projectile_curve_height, 8.0)

const DEATH_EFFECT = preload("res://Effects/DeathEffect.tscn")
func death_animation():
	$AnimationPlayer.play("death")
	yield(get_tree().create_timer(1),"timeout")
	var death_effect = DEATH_EFFECT.instance()
	get_tree().current_scene.add_child(death_effect)
	death_effect.global_translation = $"%DeathEffectSpawn".global_translation
	queue_free()

func hurt_visuals():
	for m in $Model.get_children():
		if m is MeshInstance:
			m = m as MeshInstance
			if m.material_overlay != null:
				$HurtTween.interpolate_property(m.material_overlay, "albedo_color:a", .7, .0, .4)
	$HurtTween.start()
