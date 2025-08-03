extends Node
class_name RtlReader
#THIS IS FOR DEBUGGING
@export var mesh_resource: Mesh = BoxMesh.new()

var position: int = 0;
var buffer: FileBuffer
var obstacleList: Array[SpotLight3D]

func _init(file_buffer: FileBuffer) -> void:
	buffer = file_buffer
 
func read_rtl():
	var nu20_loc: int

	var fileVersion: int = buffer.getInt32()
	var possibleLightCount = 0x80
	if fileVersion == 0:
		possibleLightCount = 0x80
	if fileVersion == 1:
		possibleLightCount = 0x0
	if fileVersion == 2:
		possibleLightCount = 0x40
	if fileVersion == 3:
		possibleLightCount = 0x40
	for i in range(possibleLightCount):
		#Chunk reader
		var position = buffer.getVec3()
		var rotation = buffer.getVec3()
		var tempColour = buffer.getVec3()
		var colour = buffer.getVec3()
		var flickerColour = buffer.getVec3()
		var radius = buffer.getFloat()
		var falloff = buffer.getFloat()
		buffer.position += 20
		var typeNum = buffer.getInt16()
		buffer.position += 48
		if typeNum != 0:
			var spotlight = SpotLight3D.new()
			spotlight.position = position
			spotlight.rotation = rotation
			spotlight.light_color = Color(tempColour.x*255,tempColour.y*255,tempColour.z*255)
			#TEMPORARY
			var mesh_instance = MeshInstance3D.new()
			mesh_instance.mesh = mesh_resource
			spotlight.add_child(mesh_instance)
			obstacleList.append(spotlight)
			
		
	# print(obstacleList)
		
	return obstacleList
