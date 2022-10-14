extends Spatial
tool


export var texture_albedo: Texture setget set_texture
export var extra_scaling: Vector3 = Vector3(1.0, 1.0, 1.0) setget set_extra_scaling
export var disable_automatic_scaling: bool


func set_texture(new_texture: Texture):
	texture_albedo = new_texture
	$Mesh.get_active_material(0).set_shader_param("texture_albedo", texture_albedo)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Engine.editor_hint:
		set_notify_transform(true)
		set_notify_local_transform(true)
	$Mesh.get_active_material(0).set_shader_param("uv1_scale", extra_scaling * scale)


func set_extra_scaling(extra):
	extra_scaling = extra
	if is_inside_tree():

		if is_instance_valid($Mesh):
			$Mesh.get_active_material(0).set_shader_param("uv1_scale", extra_scaling * scale)

# TODO THIS SHOULD ONLY BE IN TOOL MODE
func _notification(what: int) -> void:
	if Engine.editor_hint and not disable_automatic_scaling:
		if what == NOTIFICATION_TRANSFORM_CHANGED:
			$Mesh.get_active_material(0).set_shader_param("uv1_scale", extra_scaling * scale)


