extends Node
class_name Spline
@export var Name: String
@export var SpecialName: String
@export var SplineType: String
var spline_color = Color.BLUE

func Render():
	var _mesh_instance = MeshInstance3D.new()
	add_child(_mesh_instance)
	var curve = Curve3D.new()
	for point in get_children():
		if point is SplineControlPoint:
			curve.add_point(point.position)
	var line_points = curve.tessellate(1)
	var mesh = ArrayMesh.new()
	var surface_array = []
	surface_array.resize(Mesh.ARRAY_MAX)
	surface_array[Mesh.ARRAY_VERTEX] = line_points
	
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_LINE_STRIP, surface_array)

	var material = StandardMaterial3D.new()
	material.albedo_color = spline_color
	material.shading_mode = StandardMaterial3D.SHADING_MODE_UNSHADED
	
	_mesh_instance.mesh = mesh
	_mesh_instance.material_override = material
