extends KinematicBody

enum STATES {IDLE, AGGRO, DASH, AFTER_DASH, DEATH}
var state = STATES.IDLE

var walk_speed := .4
export var gravity_multiplier := 3.0
export var speed := 10
export var acceleration := 8
export var deceleration := 10
export(float, 0.0, 1.0, 0.05) var air_control := 0.3
export var jump_height := 10
var direction := Vector3()
var input_axis := Vector2()
var velocity := Vector3()
var snap := Vector3()
var up_direction := Vector3.UP
var stop_on_slope := true
onready var floor_max_angle: float = deg2rad(45.0)
onready var gravity = (ProjectSettings.get_setting("physics/3d/default_gravity") * gravity_multiplier)

var knockback := Vector3.ZERO

export var dash_chance := .5
export var dash_range := 5.0
export var dash_acc := 3.0

func _physics_process(delta):
	match state:
		STATES.AGGRO:
			var direction_to_player := self.global_translation.direction_to(Game.player.global_translation)
			direction_to_player.y = 0.0
			var normalized_walk_direction := direction_to_player.normalized()
			direction = normalized_walk_direction * walk_speed
			
			if dash_chance != 0.0:
				if Game.player.global_translation.distance_to(self.global_translation) < dash_range:
					if randf() < dash_chance * delta:
						state = STATES.DASH
			
		STATES.DASH:
			direction = Vector3.ZERO
			state = STATES.AFTER_DASH
			dash()
			
	
	if is_on_floor():
		snap = -get_floor_normal() - get_floor_velocity() * delta
		
		# Workaround for sliding down after jump on slope
		if velocity.y < 0:
			velocity.y = 0
		
	else:
		# Workaround for 'vertical bump' when going off platform
		if snap != Vector3.ZERO && velocity.y != 0:
			velocity.y = 0
		
		snap = Vector3.ZERO
		
		velocity.y -= gravity * delta
		
	if knockback != Vector3.ZERO:
		velocity -= knockback
		knockback = Vector3.ZERO
	
	accelerate(delta)
	
	
	velocity = move_and_slide_with_snap(velocity, snap, up_direction, stop_on_slope, 4, floor_max_angle)
	if state != STATES.IDLE:
		self.look_at(Game.player.global_translation, Vector3.UP)

func accelerate(delta: float) -> void:
	# Using only the horizontal velocity, interpolate towards the input.
	var temp_vel := velocity
	temp_vel.y = 0
	
	var temp_accel: float
	var target: Vector3 = direction * speed
	
	if direction.dot(temp_vel) > 0:
		temp_accel = acceleration
	else:
		temp_accel = deceleration
	
	if not is_on_floor():
		temp_accel *= air_control
	
	temp_vel = temp_vel.linear_interpolate(target, temp_accel * delta)
	
	velocity.x = temp_vel.x
	velocity.z = temp_vel.z

var hp := 50
func damage(amount: int, damage_position: Vector3):
	hp -= amount

	knockback = self.global_translation.direction_to(damage_position + Vector3.UP) * 24
	hurt_visuals()
	if hp <= 0:
		if state != STATES.DEATH:
			death_animation()
			state = STATES.DEATH
			direction = Vector3.ZERO
			$Hitbox.queue_free()

func trigger():
	if state == STATES.IDLE:
		state = STATES.AGGRO

func dash():
	pass # TODO Warning
#	print("REEEE")
	yield(get_tree().create_timer(1.5),"timeout")
	if state == STATES.DEATH:
		return
	direction = self.global_translation.direction_to(Game.player.global_translation) * dash_acc
	yield(get_tree().create_timer(.3),"timeout")
	direction = Vector3.ZERO
	yield(get_tree().create_timer(1),"timeout")
	if state == STATES.DEATH:
		return
	state = STATES.AGGRO

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
	$HurtTween.reset_all()
	for m in $Model.get_children():
		if m is MeshInstance:
			m = m as MeshInstance
			if m.material_override != null:
				$HurtTween.interpolate_property(m.material_override, "shader_param/hurt_mix", 0.0, 1.0, .4)
	$HurtTween.start()
