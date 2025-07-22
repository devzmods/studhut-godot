extends Node
class_name SceneReader

const NU20_INT: int = 808605006

var position: int = 0;
var buffer: FileBuffer

func _init(file_buffer: FileBuffer) -> void:
	buffer = file_buffer
 
func read_scene():
	var nu20_loc: int

	var first_int: int = buffer.getInt32()
	if first_int == NU20_INT:
		Project.SCENE_FORMAT = Project.SceneFormat.LIJ
		nu20_loc = 0
	else:
		Project.SCENE_FORMAT = Project.SceneFormat.TCS
		position = 0
		nu20_loc = buffer.getInt32() + 4
	
	print("SCENE FORMAT: ", Project.SCENE_FORMAT)

	position = nu20_loc + 0x18
		
