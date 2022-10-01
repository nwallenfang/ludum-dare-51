extends Node

export var icon: Texture
export var event_name: String

func event():
	print("grow event ", event_name)
