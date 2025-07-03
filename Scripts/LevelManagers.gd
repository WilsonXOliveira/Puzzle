extends Control

var list_index: int 

func _ready():
	var increment: int = -1
	var levels: Array[bool] 
	if !Global.levels_completed.is_empty():
		var saved_level = Global.levels_completed[list_index]
		for b in get_child_count():
			var button = get_child(b)
			
			if b < saved_level.size():
				button.is_completed = saved_level[b]
				button.change_texture()
		return
	
	for n in get_children():
		increment += 1
		levels.append(n.is_completed)
		n.level_index = increment
		n.level_list_index = Global.levels_completed.size()

	
	Global.levels_completed.append(levels)
	print(Global.levels_completed)
