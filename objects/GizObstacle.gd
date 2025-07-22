extends Node3D
class_name GizObstacle

#Temporary
@export var mesh_resource: Mesh = BoxMesh.new()

@export var Name: String
var _position: Vector3
@export var Position: Vector3:
	set(new_value):
		_position = new_value
		position = new_value
	get:
		return _position
var _rotation: Vector3
@export var Rotation: Vector3:
	set(new_value):
		_rotation = new_value
		rotation = new_value
	get:
		return _rotation
var _scale: Vector3
@export var Scale: Vector3:
	set(new_value):
		_scale = new_value
		scale = new_value
	get:
		return _scale
	
	
func _ready():
	var mesh_instance = MeshInstance3D.new()
	
	# 2. Assign the mesh resource to it.
	#    This uses the exported variable, so you can change it in the editor.
	mesh_instance.mesh = mesh_resource
	# 4. Add the new MeshInstance3D as a child of this node.
	#    This makes it visible and part of the scene tree.
	add_child(mesh_instance)
	var Tlabel = Label3D.new()
	Tlabel.billboard = true
	Tlabel.no_depth_test = true
	add_child(Tlabel)
	Tlabel.position = Vector3(0,1,0)
	Tlabel.text = Name
  
