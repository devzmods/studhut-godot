extends Node
class_name SceneReader

const NU20_INT: int = 808605006
var pointerArray = []
var position: int = 0;
var buffer: FileBuffer
var textureList: Array[GscTexture]
var modelList = []


static func triangle_strip_to_obj_faces(strip_indices):
		var faces = []
		for i in range(len(strip_indices) - 2):
			var v1 
			var v2 
			var v3
			if (i % 2) == 0:
				v1 = strip_indices[i] + 1
				v2 = strip_indices[i + 1] + 1
				v3 = strip_indices[i + 2] + 1
			else:
				v1 = strip_indices[i + 1] + 1
				v2 = strip_indices[i] + 1
				v3 = strip_indices[i + 2] + 1
			var face_line = "f %d %d %d" % [v1, v2, v3]
			faces.append(face_line)
		return faces
		






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
	buffer.position = 0x18 # skip garbage headers
	var pointerListLocation = buffer.getInt32()+buffer.position - 8
	buffer.position = pointerListLocation +4 #skip PNTR header
	var ammountOfPointers = buffer.getInt32()

	for pointerCount in range(ammountOfPointers):
		pointerArray.append(buffer.getInt32())
	# go back to top of file to get to scene list
	buffer.position = 0x1c
	var sceneListPointer = buffer.getInt32()+buffer.position-8
	buffer.position = sceneListPointer+0x8
	var textureCount = buffer.getInt32()
	var imageMetadataOffset = buffer.getInt32() +buffer.position-4
	var ddsDataPointer = pointerListLocation + ammountOfPointers*4 + 4+12+4
	var temporaryPointer = buffer.position
	for i in range(textureCount):
		buffer.position = imageMetadataOffset
		var relative_offset = buffer.getInt32() #this is really bad i gotta redo all of this
		buffer.position = relative_offset + imageMetadataOffset
		var imagex = buffer.getInt32()
		buffer.position = relative_offset + imageMetadataOffset +4
		var imagey = buffer.getInt32()
		var size_location = relative_offset + imageMetadataOffset + 0x44
		buffer.position = size_location
		var currentImageSize = buffer.getInt32()
		var imageBuffer = buffer.array.slice(ddsDataPointer+128,ddsDataPointer+currentImageSize)
		imageMetadataOffset = imageMetadataOffset + 4
		var outputTexture = GscTexture.new() 
		outputTexture.Data = Image.create_from_data(imagex,imagey,true,Image.FORMAT_DXT1,imageBuffer) #THIS NEEDS TO BE WAY BETTER
		if not outputTexture.ImageTex:
			#print("first time failed")
			outputTexture.Data = Image.create_from_data(imagex,imagey,false,Image.FORMAT_DXT1,imageBuffer) #THIS NEEDS TO BE WAY BETTER
		if not outputTexture.ImageTex:
			#print("seccond time failed")
			outputTexture.Data = Image.create_from_data(imagex,imagey,false,Image.FORMAT_DXT5,imageBuffer) #THIS NEEDS TO BE WAY BETTER
		if not outputTexture.ImageTex:
			#print("third time failed")
			outputTexture.Data = Image.create_from_data(imagex,imagey,true,Image.FORMAT_DXT5,imageBuffer) #THIS NEEDS TO BE WAY BETTER
		textureList.append(outputTexture)
		ddsDataPointer = ddsDataPointer + currentImageSize
	buffer.position = ddsDataPointer
	var vertexListCount = buffer.getInt16()
	var vertexLists = []
	
	for i in range(vertexListCount):
		var vertexListSize = buffer.getInt32()
		vertexLists.append(buffer.position)
		buffer.position += vertexListSize
	
	var numberOfIndicieLists = buffer.getInt16()
	var indiciesList = []
	for i in range(numberOfIndicieLists):
		var size = buffer.getInt32()
		indiciesList.append(buffer.position)
		buffer.position += size
	sceneListPointer = sceneListPointer -4
	var base_address = sceneListPointer + 0x1d8

	buffer.position = base_address

	var partsNumberPtrOffset = buffer.getInt32()

	# Calculate the absolute location of the parts data structure using the original base address
	var parts_data_location = base_address + partsNumberPtrOffset

	# Set the buffer position directly to where partsNumber is stored (target + 20 bytes)
	buffer.position = parts_data_location + 20

	# Now, read the number of parts from the correct location
	var partsNumber = buffer.getInt16()
	buffer.position = parts_data_location+0x20 
	buffer.position += buffer.getInt32()-4
	print(buffer.position)
	for i in range(partsNumber):
		buffer.position += 4
		var numberOfIndicies = buffer.getInt32()
		var vertexSize = buffer.getInt16()
		buffer.position += 10
		var offsetVerticies = buffer.getInt32()
		var numberOfVerticies = buffer.getInt32()
		var offsetIndicies = buffer.getInt32()
		var indexList = buffer.getInt32()
		var vertexList = buffer.getInt16()
		buffer.position += 18
		var bufferPositionSaved = buffer.position

		#this can be done better later
		var obj_file = ""
		obj_file = obj_file + ("# OBJ file created from GSC data\n")
		for vertex in range(numberOfVerticies):
			var xPointer = vertexLists[vertexList] + offsetVerticies * vertexSize + vertex * vertexSize
			var yPointer = vertexLists[vertexList] + offsetVerticies * vertexSize + vertex * vertexSize + 4
			var zPointer = vertexLists[vertexList] + offsetVerticies * vertexSize + vertex * vertexSize + 8
			buffer.position = xPointer
			var x = buffer.getFloat()
			buffer.position = yPointer
			var y = buffer.getFloat()
			buffer.position = zPointer
			var z = buffer.getFloat()
			obj_file = obj_file + ("v %.6f %.6f %.6f\n" % [x, y, z])
		var indices = []
		var indexBuffer = indiciesList[indexList]
		for index in range(numberOfIndicies + 2):
			var indexBufferPointer = indexBuffer + offsetIndicies * 2 + index * 2
			buffer.position = indexBufferPointer
			var indexValue = buffer.getInt16()
			indices.append(indexValue)
		var obj_faces = triangle_strip_to_obj_faces(indices)
		for face in obj_faces:
			obj_file = obj_file + (face+"\n")
		var object = MeshInstance3D.new()
		object.mesh = ObjParse.load_obj_from_buffer(obj_file,{})
		object.visible = false
		modelList.append(object)
		buffer.position = bufferPositionSaved

	return [textureList, modelList]
	
	
	position = nu20_loc + 0x18
		
