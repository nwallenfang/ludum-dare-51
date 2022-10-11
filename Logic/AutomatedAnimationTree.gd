tool
extends AnimationTree

export var build := false setget _build
export var animation_names : Dictionary

func _build(x):
	if !x: return
	self.tree_root = AnimationNodeBlendTree.new()
	var root := self.tree_root as AnimationNodeBlendTree
	
	var player := get_node(self.anim_player) as AnimationPlayer
	
	animation_names = {}
	
	for frame_name in player.get_animation_list():
		var base_name : String = (frame_name as String).split("_")[0]
		if not base_name in animation_names:
			animation_names[base_name] = []
		animation_names[base_name].append(frame_name)
	
	var i := -1
	for animation_name in animation_names:
		i += 1
		
		var frame_name_list : Array = animation_names[animation_name]
		var frame_count := len(frame_name_list)
		
		if "loop" in animation_name:
			frame_name_list.append(frame_name_list[0])
			frame_count += 1
		
		var frame_distance := 1.0
		if frame_count != 1:
			frame_distance = 1.0 / (frame_count - 1)
		
		var blend_space := AnimationNodeBlendSpace1D.new()
		var j := -1
		for frame_name in animation_names[animation_name]:
			j += 1
			var node_animation := AnimationNodeAnimation.new()
			node_animation.animation = frame_name
			blend_space.add_blend_point(node_animation, j * frame_distance)
		
		root.add_node(animation_name, blend_space, Vector2(0, 150*i))

