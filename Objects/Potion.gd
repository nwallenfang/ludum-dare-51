extends Spatial

func set_color_background(c: Color):
	$Trank/TrankInner.material_override.set("shader_param/albedo", c)

func set_color_bubbles(c: Color):
	$Trank/TrankInner.material_override.set("shader_param/color1", c)

func set_color_background2(c: Color):
	$Trank/TrankInner.material_override.set("shader_param/color2", c)
