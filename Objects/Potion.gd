extends Spatial

export var background: Color
export var background2: Color
export var bubbles: Color


func _ready() -> void:
	set_color_background(background)
	set_color_bubbles(bubbles)
	set_color_background2(background2)

func set_color_background(c: Color):
	$Trank/TrankInner.material_override.set("shader_param/albedo", c)

func set_color_bubbles(c: Color):
	$Trank/TrankInner.material_override.set("shader_param/color1", c)

func set_color_background2(c: Color):
	$Trank/TrankInner.material_override.set("shader_param/color2", c)
