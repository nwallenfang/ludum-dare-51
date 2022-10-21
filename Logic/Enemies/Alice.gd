extends Spatial

export var shooting_distance := 30.0
export var projectile_curve_height := .2
export var max_health := 50

export var special_attacks := false
export var shoot_cooldown := 4.0

enum STATES {IDLE, AGGRO, SHOOTING, SHOOT_COOLDOWN, DEATH}
var state = STATES.IDLE

var hp := max_health
func damage(amount: int, _damage_position: Vector3, _laser:bool):
	if state == STATES.IDLE:
		var trigger_group = ""
		for g in get_groups():
			if g.begins_with("trigger"):
				trigger_group = g
				break
		if trigger_group != "":
			get_tree().call_group(trigger_group, "trigger")
		else:
			trigger()
	
	hp -= amount
	hurt_visuals()
	if hp <= 0:
		if state != STATES.DEATH:
			death_animation()
			state = STATES.DEATH

func trigger():
	if state == STATES.IDLE:
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
			$ShootCooldown.start(shoot_cooldown + (randf() * 2.0 - 1.0))
			state = STATES.SHOOT_COOLDOWN
		STATES.SHOOT_COOLDOWN:
			if $ShootCooldown.time_left <= 0.05:
				state = STATES.AGGRO

const PROJECTILE = preload("res://Logic/Enemies/Projectile.tscn")
func make_shot():
	var shot_type = randi() % 3
	if not special_attacks: shot_type = 0
	
	match shot_type:
		0:
			var projectile = PROJECTILE.instance()
			get_tree().current_scene.add_child(projectile)
			projectile.global_translation = $"%ShotPoint".global_translation
			projectile.fly($"%ShotPoint".global_translation, Game.player.global_translation, dist_to_player * projectile_curve_height, 9.5)
		1:
			for i in range(2):
				var projectile = PROJECTILE.instance()
				get_tree().current_scene.add_child(projectile)
				projectile.global_translation = $"%ShotPoint".global_translation
				projectile.scale = Vector3.ONE * 1.8
				projectile.fly($"%ShotPoint".global_translation, Game.player.global_translation, dist_to_player * projectile_curve_height, 10.0)
				yield(get_tree().create_timer(1.5),"timeout")
		2:
			for i in range(4):
				var projectile = PROJECTILE.instance()
				get_tree().current_scene.add_child(projectile)
				projectile.global_translation = $"%ShotPoint".global_translation
				projectile.scale = Vector3.ONE * .7
				projectile.fly($"%ShotPoint".global_translation, Game.player.global_translation, dist_to_player * projectile_curve_height, 13.0)
				yield(get_tree().create_timer(.6),"timeout")

const DEATH_EFFECT = preload("res://Effects/DeathEffect.tscn")
func death_animation():
	AudioManager.play("robo_death")
	$AnimationPlayer.play("death")
	yield(get_tree().create_timer(1),"timeout")
	var death_effect = DEATH_EFFECT.instance()
	get_tree().current_scene.add_child(death_effect)
	death_effect.global_translation = $"%DeathEffectSpawn".global_translation
	queue_free()

func hurt_visuals():
	for m in $Model.get_children():
		for mm in m.get_children():
			if mm is MeshInstance:
				mm = mm as MeshInstance
				if mm.material_overlay != null:
					$HurtTween.interpolate_property(mm.material_overlay, "albedo_color:a", 1, .0, .4)
		if m is MeshInstance:
			m = m as MeshInstance
			if m.material_overlay != null:
				$HurtTween.interpolate_property(m.material_overlay, "albedo_color:a", 1, .0, .4)
	$HurtTween.start()
