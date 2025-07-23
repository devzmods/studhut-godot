extends Node
class_name FileBuffer

var array: PackedByteArray
var position = 0

func _init(buffer_array: PackedByteArray) -> void:
	array = buffer_array

func getInt8() -> int:
	var result: int = array.decode_s8(position)
	position += 1
	return result

func getInt16() -> int:
	var result: int = array.decode_s16(position)
	position += 2
	return result

func getInt32() -> int:
	var result: int = array.decode_s32(position)
	position += 4
	return result

func getFloat() -> float:
	var result: float = array.decode_float(position)
	position += 4
	return result

func getVec3() -> Vector3:
	var result = Vector3(array.decode_float(position), array.decode_float(position + 4), array.decode_float(position + 8))
	position += 12
	return result
