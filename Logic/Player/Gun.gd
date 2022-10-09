extends Spatial

const laser_scene_path = preload("res://Logic/Player/LaserDrawer.tscn")

var ray_path := NodePath("RayCast")
onready var ray: RayCast = get_node(ray_path)

var laser_sound_path := NodePath("../../LaserStream")
var banana_sound_path := NodePath("../../BananaStream")
onready var laser_sound: AudioStreamPlayer = get_node(laser_sound_path)
onready var banana_sound: AudioStreamPlayer = get_node(banana_sound_path)

var autofire = false setget set_autofire


func shoot():
	if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED and not Game.settings_open:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		return
	if $Firerate.time_left > 0.0:
		return
	$Firerate.start()
	
	# Update the ray and get the collided object
	ray.set_cast_to(Vector3(0,0,-10000000000))
	ray.force_raycast_update()
	
	if !ray.is_colliding():
		return

	var collider: Object = ray.get_collider().get_parent()

	var hit_point: Vector3 = ray.get_collision_point()
	var hit_normal: Vector3 = ray.get_collision_normal()
	
	if collider is LevelSelectButton:
		get_tree().set_input_as_handled()
		collider.button_effect()
	
	if not Events.explosion_on_shot:
		if Events.second_gun:
			if collider.has_method("damage"):
				# Call it with damage
				collider.damage(10, self.global_translation)
				var hit = HIT_PARTICLES.instance()
				get_tree().current_scene.add_child(hit)
				hit.global_translation = hit_point
				hit.particles_look_at(hit_normal)
			else:
				var stain = LASER_STAIN.instance()
				get_tree().current_scene.add_child(stain)
				stain.global_translation = hit_point + hit_normal * .05 + Vector3.UP * .1
		# If the target can be damaged
		if collider.has_method("damage"):
			# Call it with damage
			collider.damage(10, self.global_translation)
			var hit = HIT_PARTICLES.instance()
			get_tree().current_scene.add_child(hit)
			hit.global_translation = hit_point
			hit.particles_look_at(hit_normal)
		else:
			var stain = LASER_STAIN.instance()
			get_tree().current_scene.add_child(stain)
			stain.global_translation = hit_point + hit_normal * .05
	else:
		var ex = EXPLOSION.instance()
		get_tree().current_scene.add_child(ex)
		ex.global_translation = hit_point + hit_normal * .2
		
	
	if Events.second_gun:
		var laser_drawer = laser_scene_path.instance()
		get_tree().current_scene.add_child(laser_drawer)
		laser_drawer.draw_line(Game.player.get_node("%GunHead2").global_translation, hit_point + Vector3.UP * .1)
	
	var laser_drawer = laser_scene_path.instance()
	get_tree().current_scene.add_child(laser_drawer)
	laser_drawer.draw_line(Game.player.get_node("%GunHead").global_translation, hit_point)
	
	if not autofire:
		if not Events.banana:
			AudioManager.play("laser")
		else:
			AudioManager.play("pew")


const LASER_STAIN = preload("res://Effects/LaserStain.tscn")
const EXPLOSION = preload("res://Effects/Explosion.tscn")
const HIT_PARTICLES = preload("res://Effects/HitParticles.tscn")
func _input(event: InputEvent):
	if Game.settings_open:
		return
	if not Game.player.movement_disabled and Input.is_action_just_pressed("shoot"):
#		if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED and not Game.settings_open:
#			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
#			return
#		if $Firerate.time_left > 0.0:
#			return
#		$Firerate.start()
#
#		# Update the ray and get the collided object
#		ray.set_cast_to(Vector3(0,0,-10000000000))
#		ray.force_raycast_update()
#
#		if !ray.is_colliding():
#			return
#
#		var collider: Object = ray.get_collider().get_parent()
#
#		var hit_point: Vector3 = ray.get_collision_point()
#		var hit_normal: Vector3 = ray.get_collision_normal()
#
#		if not Events.explosion_on_shot:
#			if Events.second_gun:
#				if collider.has_method("damage"):
#					# Call it with damage
#					collider.damage(10, true)
#					var hit = HIT_PARTICLES.instance()
#					get_tree().current_scene.add_child(hit)
#					hit.global_translation = hit_point
#					hit.particles_look_at(hit_normal)
#				else:
#					var stain = LASER_STAIN.instance()
#					get_tree().current_scene.add_child(stain)
#					stain.global_translation = hit_point + hit_normal * .05 + Vector3.UP * .1
#			# If the target can be damaged
#			if collider.has_method("damage"):
#				# Call it with damage
#				collider.damage(10, true)
#				var hit = HIT_PARTICLES.instance()
#				get_tree().current_scene.add_child(hit)
#				hit.global_translation = hit_point
#				hit.particles_look_at(hit_normal)
#			else:
#				var stain = LASER_STAIN.instance()
#				get_tree().current_scene.add_child(stain)
#				stain.global_translation = hit_point + hit_normal * .05
#		else:
#			# Explosion
#			var ex = EXPLOSION.instance()
#			get_tree().current_scene.add_child(ex)
#			ex.global_translation = hit_point + hit_normal * .2
#
#
#		if Events.second_gun:
#			var laser_drawer = laser_scene_path.instance()
#			get_tree().current_scene.add_child(laser_drawer)
#			laser_drawer.draw_line(Game.player.get_node("%GunHead2").global_translation, hit_point + Vector3.UP * .1)
#
#		var laser_drawer = laser_scene_path.instance()
#		get_tree().current_scene.add_child(laser_drawer)
#		laser_drawer.draw_line(Game.player.get_node("%GunHead").global_translation, hit_point)
#
#
#		if not autofire:
#			if not Events.banana:
#				laser_sound.play()
#			else:
#				banana_sound.play()
		shoot()


func set_autofire(val):
	$Firerate.start()
	if val:
		AudioManager.play("laser_autofire")
	else:
		AudioManager.stop("laser_autofire")
	autofire = val



func _on_Firerate_timeout() -> void:
	if autofire:
		shoot()
