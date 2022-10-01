extends Spatial


func _ready():
	pass


func _on_Area_area_entered(area):
	Game.level.has_key = true
