extends Spatial

var viewport_material: SpatialMaterial
var fixed_materials = []
var screen_materials = []

onready var screen = $Screen

var noise_icon_material = preload("res://Assets/Materials/EventIconMat.tres")
var only_noise_material = preload("res://Assets/Materials/NoiseMaterial2.tres")
	
func set_texture(viewport: Viewport):
	if viewport == null:
		return

	var viewport_tex: ViewportTexture = viewport.get_texture()
	viewport_tex.viewport_path = NodePath("/root/World/Viewport2D")

	viewport_material.albedo_texture = viewport_tex
	
	screen_materials.clear()
	screen_materials = fixed_materials.duplicate()
	screen_materials.append(viewport_material)
	screen.material_override = viewport_material


func new_event_triggered(event):
#	screen.material_override = viewport_material
	var rand_index = randi() % 2
	noise_icon_material.set_shader_param("icon", event.icon)
	
	match rand_index:
		0: 
			# Event name / 2D Viewport
			screen.material_override = viewport_material
		1:
			# Event icon
			# Noise
#			var noise_obj: OpenSimplexNoise = noise_material.get_shader_param("noise").noise
			screen.material_override = noise_icon_material


#		3:
#			# Healthbar
#			# Noise
#			var noise_obj: OpenSimplexNoise = noise_material.get_shader_param("noise").noise
#			screen.material_override = noise_material
	if $ChangeScreenTimer.is_stopped():
		yield(get_tree().create_timer(randf()), "timeout")
		$ChangeScreenTimer.start(min_wait + (max_wait - min_wait) * randf())


var min_wait = 1.1
var max_wait = 1.7
func _ready() -> void:
	viewport_material = $Screen.get_active_material(0).duplicate()
	Game.connect("viewport_texture_changed", self, "set_texture")
	Events.connect("trigger_event", self, "new_event_triggered")
	$AnimationPlayer.play("noise_run")



export var change_screen_chance = 0.18
func _on_ChangeScreenTimer_timeout() -> void:
	if randf() < change_screen_chance:
		if screen.material_override == noise_icon_material:
			screen.material_override = only_noise_material
			yield(get_tree().create_timer(0.3 + 0.4 * randf()), "timeout")
			screen.material_override = viewport_material
		elif screen.material_override == viewport_material:
			screen.material_override = only_noise_material
			yield(get_tree().create_timer(0.3 + 0.4 * randf()), "timeout")
			screen.material_override = noise_icon_material
