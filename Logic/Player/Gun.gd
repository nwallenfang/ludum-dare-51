extends Spatial

const laser_scene_path = preload("res://Logic/Player/LaserDrawer.tscn")

var ray_path := NodePath("RayCast")
onready var ray: RayCast = get_node(ray_path)

var laser_sound_path := NodePath("../../LaserStream")
onready var laser_sound: AudioStreamPlayer = get_node(laser_sound_path)

func _ready():
	pass

func _input(event: InputEvent):
	if not Game.player.movement_disabled and Input.is_action_just_pressed("shoot"):
		# Update the ray and get the collided object
		ray.set_cast_to(Vector3(0,0,-10000000000))
		ray.force_raycast_update()
		
		if !ray.is_colliding():
			return

		var collider: Object = ray.get_collider().get_parent()

		# If the target can be damaged
		if collider.has_method("damage"):
			# Call it with damage
			collider.damage(10)
			
		var hit_point: Vector3 = ray.get_collision_point()
			
		# TODO: Call laser sound
		
		var laser_drawer = laser_scene_path.instance()
		get_tree().current_scene.add_child(laser_drawer)
		
		laser_drawer.draw_line(Game.player.get_node("%GunHead").global_translation, hit_point)
		
		laser_sound.play()
		

