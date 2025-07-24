extends Node
class_name GscTexture

@export var Name: String
@export var Id: int
@export var Size: int
var _Data: Image
@export var ImageTex: Texture2D
@export var Data: Image:
	set(new_value):
		_Data = new_value
		ImageTex = ImageTexture.create_from_image(new_value)
	get:
		return _Data
