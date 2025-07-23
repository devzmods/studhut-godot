extends Node
class_name SplineReader

const SplineMagic: int = 1347634245

var buffer: FileBuffer
var splineList: Array[Spline]

func _init(file_buffer: FileBuffer) -> void:
	buffer = file_buffer
 
func read_spline():
	var nu20_loc: int

	var first_int: int = buffer.getInt32()
	if first_int == 1347634245:
		print("Good Spline file")
		Project.SCENE_FORMAT = Project.SceneFormat.LIJ
		nu20_loc = 0
	else:
		print("Bad file")
		return 0
	buffer.position = 12
	var version = buffer.getInt32()
	var splineCount = buffer.getInt32()
	buffer.getInt32()
	buffer.getInt32()
	
	#for sp in range(splineCount):
	for sp in range(splineCount):
		var currentSpline = Spline.new()
		buffer.getInt8()
		var splineNameLength = buffer.getInt32()
		var controlPoints = buffer.getInt32()
		var splineName = buffer.array.slice(buffer.position,buffer.position+splineNameLength).get_string_from_ascii()
		buffer.position = buffer.position+splineNameLength
		currentSpline.name = splineName
		currentSpline.Name = splineName
		var specialLength = buffer.getInt16()
		var splineSpecialName = buffer.array.slice(buffer.position,buffer.position+specialLength).get_string_from_ascii()
		currentSpline.SpecialName = splineSpecialName
		buffer.position = buffer.position+specialLength
		for point in range(controlPoints):
			
			var currentPoint = SplineControlPoint.new()
			currentPoint.position = buffer.getVec3()
			currentPoint.scale = Vector3(0.2, 0.2, 0.2)
			currentPoint.Name = "Control Point " + str(point)
			currentPoint.name = "Control Point " + str(point)
			currentSpline.add_child(currentPoint)
		currentSpline.Render()
		var splineTypeLength = buffer.getInt8()
		# var splineType = buffer.array.slice(buffer.position,buffer.position+splineTypeLength).get_string_from_ascii()
		buffer.position = buffer.position+splineTypeLength
		splineList.append(currentSpline)
		
	return splineList
	
	
		
