extends Node
class_name SceneReader

const NU20_INT: int = 808605006
var pointerArray = []
var position: int = 0;
var buffer: FileBuffer
var textureList: Array[GscTexture]

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
		
	return textureList
	
	
	position = nu20_loc + 0x18
		
