extends Node
class_name GizReader

const GizMagic: int = 1

var position: int = 0;
var buffer: PackedByteArray
var obstacleList: Array[GizObstacle]

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
	while position+5 < buffer.size():
		#Chunk reader
		var chunkNameLength = getInt32()
		var chunkName = buffer.slice(position,position+chunkNameLength).get_string_from_ascii()
		position = position+chunkNameLength
		var chunkPayloadLength = getInt32()
		#print("Found Chunk: " + chunkName)
		if chunkName == "GizObstacle":
			var obstacleVersion = getInt8()
			var obstacleCount = getInt16()
			for i in range(obstacleCount):
				var currentGizmo = GizObstacle.new()
				currentGizmo.Name = buffer.slice(position,position+16).get_string_from_ascii()
				currentGizmo.name = currentGizmo.Name
				position = position+16
				currentGizmo.Position = getVec3()
				currentGizmo.Rotation = getVec3()
				getFloat()
				getFloat()
				currentGizmo.Scale = getVec3()
				getInt16()
				getInt32()
				getInt32()
				getInt8()
				getInt8()
				getFloat()
				getFloat()
				getFloat()
				getFloat()
				getInt8()
				#animation stuff
				var animationVersion = getInt8()
				var animationCount = getInt8()
				for x in range(animationCount):
					var aniNameLength = getInt8()
					# here is where the animation name goes but its not important for now
					position = position + aniNameLength
					getFloat()
					getFloat()
					getFloat()
					getInt16()
				getFloat() #radius1
				getFloat() #radius2
				getFloat() #radius3
				#blowup string stuff (not saving for now)
				var blowUpNameLength = getInt8()
				position = position + blowUpNameLength
				getInt16() #blowup id
				getInt16()
				getInt16()
				getInt16()
				getVec3()
				getFloat()
				getFloat()
				getFloat()
				getInt8()
				#print(currentGizmo.Name)
				obstacleList.append(currentGizmo)
		else:
			position = position+chunkPayloadLength
		
	return obstacleList
	
	
		
