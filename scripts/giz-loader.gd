extends Node
class_name GizReader

const GizMagic: int = 1

var position: int = 0;
var buffer: FileBuffer
var obstacleList: Array[GizObstacle]

func _init(file_buffer: FileBuffer) -> void:
	buffer = file_buffer
 
func read_giz():
	var nu20_loc: int

	var first_int: int = buffer.getInt32()
	if first_int == GizMagic:
		print("Good GIZ file")
		Project.SCENE_FORMAT = Project.SceneFormat.LIJ
		nu20_loc = 0
	else:
		print("Bad file")
		return 0
	while buffer.position + 5 < buffer.array.size():
		#Chunk reader
		var chunkNameLength = buffer.getInt32()
		var chunkName = buffer.array.slice(buffer.position, buffer.position + chunkNameLength).get_string_from_ascii()
		buffer.position += chunkNameLength
		var chunkPayloadLength = buffer.getInt32()
		# print("Found Chunk: " + chunkName)
		if chunkName == "GizObstacle":
			var obstacleVersion = buffer.getInt8()
			var obstacleCount = buffer.getInt16()
			for i in range(obstacleCount):
				var currentGizmo = GizObstacle.new()
				currentGizmo.Name = buffer.array.slice(buffer.position, buffer.position + 16).get_string_from_ascii()
				currentGizmo.name = currentGizmo.Name
				buffer.position += 16
				currentGizmo.Position = buffer.getVec3()
				currentGizmo.Rotation = buffer.getVec3()
				buffer.getFloat()
				buffer.getFloat()
				currentGizmo.Scale = buffer.getVec3()
				buffer.getInt16()
				buffer.getInt32()
				buffer.getInt32()
				buffer.getInt8()
				buffer.getInt8()
				buffer.getFloat()
				buffer.getFloat()
				buffer.getFloat()
				buffer.getFloat()
				buffer.getInt8()
				#animation stuff
				var animationVersion = buffer.getInt8()
				var animationCount = buffer.getInt8()
				for x in range(animationCount):
					var aniNameLength = buffer.getInt8()
					# here is where the animation name goes but its not important for now
					buffer.position += aniNameLength
					buffer.getFloat()
					buffer.getFloat()
					buffer.getFloat()
					buffer.getInt16()
				buffer.getFloat() # radius1
				buffer.getFloat() # radius2
				buffer.getFloat() # radius3
				#blowup string stuff (not saving for now)
				var blowUpNameLength = buffer.getInt8()
				buffer.position += blowUpNameLength
				buffer.getInt16() # blowup id
				buffer.getInt16()
				buffer.getInt16()
				buffer.getInt16()
				buffer.getVec3()
				buffer.getFloat()
				buffer.getFloat()
				buffer.getFloat()
				buffer.getInt8()
				#print(currentGizmo.Name)
				obstacleList.append(currentGizmo)

				# break
		else:
			position = position + chunkPayloadLength
	# print(obstacleList)
		
	return obstacleList
