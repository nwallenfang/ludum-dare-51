extends Spatial

export var background: Color
export var background2: Color
export var bubbles: Color

export var make_random_colors := false

func get_random_color() -> Color:
	return Color.from_hsv(randf(), randf(), 1.0)

func _ready() -> void:
	if make_random_colors:
		set_color_background(get_random_color())
		set_color_bubbles(get_random_color())
		set_color_background2(get_random_color())
	else:
		set_color_background(background)
		set_color_bubbles(bubbles)
		set_color_background2(background2)

func set_color_background(c: Color):
	$Trank/TrankInner.material_override.set("shader_param/albedo", c)

func set_color_bubbles(c: Color):
	$Trank/TrankInner.material_override.set("shader_param/color1", c)

func set_color_background2(c: Color):
	$Trank/TrankInner.material_override.set("shader_param/color2", c)
