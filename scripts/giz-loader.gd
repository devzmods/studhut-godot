extends Node
class_name GizReader

const GizMagic: int = 1

var position: int = 0;
var buffer: PackedByteArray

func _init(file_buffer: PackedByteArray) -> void:
	buffer = file_buffer

func getInt32():
	var result: int = buffer.decode_s32(position)
	position += 4
	return result
 
func read_giz():
	var nu20_loc: int

	var first_int: int = getInt32()
	if first_int == GizMagic:
		print("Good GIZ file")
		Project.SCENE_FORMAT = Project.SceneFormat.LIJ
		nu20_loc = 0
	else:
		print("Bad file")
		return 0
	
	position = nu20_loc + 0x18
		
