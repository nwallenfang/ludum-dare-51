extends Node

export var icon: Texture
export var event_name: String

const GRID = preload("res://Effects/LaserGrid.tscn")
func event():
	print("fixed event ", event_name)
	var grid = GRID.instance()
	Game.level.add_child(grid)
	grid.global_translation = Vector3(0, -3, 0)
	grid.speed = 1
