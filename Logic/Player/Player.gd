extends KinematicBody
class_name MovementController



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
# Get the gravity from the project settings to be synced with RigidDynamicBody nodes.
onready var gravity = (ProjectSettings.get_setting("physics/3d/default_gravity") 
		* gravity_multiplier)
var mouse_beginning_set = false


var movement_disabled = true
var default_scale
func _ready():
#	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	default_scale = self.scale
	$MeshInstance.visible = false
	yield(get_tree(), "idle_frame")
	
func _input(event: InputEvent) -> void:
	if movement_disabled:
		return
	if not mouse_beginning_set:
		mouse_beginning_set = true
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit() # Quits the game
		
	if not movement_disabled and event.is_action_pressed("shoot") and Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		get_tree().set_input_as_handled()
	
	if event.is_action_pressed("change_mouse_input"):
		match Input.get_mouse_mode():
			Input.MOUSE_MODE_CAPTURED:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			Input.MOUSE_MODE_VISIBLE:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# Called every physics tick. 'delta' is constant
func _physics_process(delta) -> void:
	if movement_disabled:
		return 
	input_axis = Input.get_vector("ui_down", "ui_up",
			"ui_left", "ui_right")
	
	direction_input()
	
	if is_on_floor():
		snap = -get_floor_normal() - get_floor_velocity() * delta
		
		# Workaround for sliding down after jump on slope
		if velocity.y < 0:
			velocity.y = 0
		
		if Input.is_action_just_pressed("jump"):
			snap = Vector3.ZERO
			velocity.y = jump_height
	else:
		# Workaround for 'vertical bump' when going off platform
		if snap != Vector3.ZERO && velocity.y != 0:
			velocity.y = 0
		
		snap = Vector3.ZERO
		
		velocity.y -= gravity * delta
	
	accelerate(delta)
	
	velocity = move_and_slide_with_snap(velocity, snap, up_direction, 
			stop_on_slope, 4, floor_max_angle)

func _process(delta: float) -> void:
	pass

func direction_input() -> void:
	direction = Vector3()
	var aim: Basis = get_global_transform().basis
	direction = aim.z * -input_axis.x + aim.x * input_axis.y


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

var max_hp := 3
var hp := max_hp

func get_hurt():
	hp = hp - 1
	$HurtTimer.start()
	print("hurt")
	if hp <= 0:
		Game.world.restart_level()

func _on_HurtBox_area_entered(area):
	if $HurtTimer.time_left == 0.0:
		get_hurt()

func _on_HurtTimer_timeout():
	for a in $HurtBox.get_overlapping_areas():
		_on_HurtBox_area_entered(a)
