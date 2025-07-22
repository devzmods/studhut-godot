extends Node
class_name SplineReader

const SplineMagic: int = 1347634245

var position: int = 0;
var buffer: PackedByteArray
var splineList: Array[Spline]

func _init(file_buffer: PackedByteArray) -> void:
	buffer = file_buffer
func getVec3():
	var result = Vector3(buffer.decode_float(position),buffer.decode_float(position+4),buffer.decode_float(position+8))
	position += 12
	return result
func getFloat():
	var result: float = buffer.decode_float(position)
	position += 4
	return result
func getInt32():
	var result: int = buffer.decode_s32(position)
	position += 4
	return result
func getInt8():
	var result: int = buffer.decode_s8(position)
	position += 1
	return result
func getInt16():
	var result: int = buffer.decode_s16(position)
	position += 2
	return result
 
func read_spline():
	var nu20_loc: int

	var first_int: int = getInt32()
	if first_int == 1347634245:
		print("Good Spline file")
		Project.SCENE_FORMAT = Project.SceneFormat.LIJ
		nu20_loc = 0
	else:
		print("Bad file")
		return 0
	position = 12
	var version = getInt32()
	var splineCount = getInt32()
	getInt32()
	getInt32()
	
	#for sp in range(splineCount):
	for sp in range(splineCount):
		var currentSpline = Spline.new()
		getInt8()
		var splineNameLength = getInt32()
		var controlPoints = getInt32()
		var splineName = buffer.slice(position,position+splineNameLength).get_string_from_ascii()
		position = position+splineNameLength
		currentSpline.name = splineName
		currentSpline.Name = splineName
		var specialLength = getInt16()
		var splineSpecialName = buffer.slice(position,position+specialLength).get_string_from_ascii()
		currentSpline.SpecialName = splineSpecialName
		position = position+specialLength
		for point in range(controlPoints):
			
			var currentPoint = SplineControlPoint.new()
			currentPoint.Position = getVec3()
			currentPoint.Name = splineName
			currentPoint.name = splineName
			currentSpline.add_child(currentPoint)
		currentSpline.Render()
		var splineTypeLength = getInt8()
		var splineType = buffer.slice(position,position+splineTypeLength).get_string_from_ascii()
		position = position+splineTypeLength
		splineList.append(currentSpline)
		
	return splineList
	
	
		
