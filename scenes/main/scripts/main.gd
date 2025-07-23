extends Node3D

var current_project: Project

var last_dir: String = ""

func _show_file_dialog(filters: Array, connect_callable: Callable):
	"""Helper function to create and show a file dialog."""
	var file_dialog = FileDialog.new()
	file_dialog.access = FileDialog.ACCESS_FILESYSTEM
	file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	file_dialog.filters = filters
	file_dialog.use_native_dialog = true
	file_dialog.current_dir = OS.get_environment("HOME") + "/Downloads"
	
	file_dialog.file_selected.connect(connect_callable)
	
	add_child(file_dialog)
	file_dialog.popup_centered()
	

func _process(_delta: float) -> void:
	var world_children: Array[Node] = get_node("worldScene").get_children()

	# --- Main Menu Bar for the entire screen ---
	if ImGui.BeginMainMenuBar():
		if ImGui.BeginMenu("File"):
			if ImGui.MenuItem("New Project.."): pass
			if ImGui.MenuItem("Open Project.."): pass
			if ImGui.MenuItem("Save Project.."): pass
			if ImGui.MenuItem("Import Scene.."):
				_show_file_dialog(["*.gsc ; TTGames Scene File"], import_scene)
			if ImGui.MenuItem("Import Gizmos.."):
				_show_file_dialog(["*.giz ; TTGames Gizmo File"], import_gizmo)
			if ImGui.MenuItem("Import Splines.."):
				_show_file_dialog(["*.spl ; TTGames Spline File"], import_spline)
			if ImGui.MenuItem("Import Text.."):
				_show_file_dialog(["*.txt ; TTGames Level/Area Text"], func() -> void: pass ) # placeholders
			if ImGui.MenuItem("Import Lighting.."):
				_show_file_dialog(["*.rtl ; TTGames Lighting File"], func() -> void: pass ) # placeholders
			ImGui.EndMenu()

	ImGui.EndMainMenuBar()
	
	
	var viewport = get_viewport().get_visible_rect()
	
	var panel_width = viewport.size.x * 0.2
	var menu_bar_height = ImGui.GetFrameHeight()
	var panel_pos = Vector2(0, menu_bar_height)
	var panel_size = Vector2(panel_width, viewport.size.y * 0.5 - menu_bar_height)

	ImGui.SetNextWindowPos(panel_pos)
	ImGui.SetNextWindowSize(panel_size)
	var window_flags = ImGui.WindowFlags_NoMove | ImGui.WindowFlags_NoResize | ImGui.WindowFlags_NoCollapse

	ImGui.Begin("Project", [], window_flags)
	
	if ImGui.TreeNode("Gizmos"): # Gizmos list
		var children = world_children
		for child in children:
			if child is GizObstacle:
				if ImGui.Selectable(child.Name): pass
		ImGui.TreePop()
	
	if ImGui.TreeNode("Splines"): # Gizmos list
		var children = world_children
		for child in children:
			if child is Spline:
				if ImGui.TreeNode(child.name):
					var spline_children = child.get_children()
					for point in spline_children:
						if point is SplineControlPoint:
							if ImGui.Selectable(point.name): pass
					ImGui.TreePop()
		ImGui.TreePop()

	ImGui.End()

	panel_pos = Vector2(0, viewport.size.y * 0.5)
	panel_size = Vector2(panel_width, viewport.size.y * 0.5)

	ImGui.SetNextWindowPos(panel_pos)
	ImGui.SetNextWindowSize(panel_size)
	
	ImGui.Begin("Imported Files", [], window_flags)
	ImGui.End()

	panel_pos = Vector2(viewport.size.x - panel_width, menu_bar_height)
	panel_size = Vector2(panel_width, viewport.size.y * 0.5 - menu_bar_height)

	ImGui.SetNextWindowPos(panel_pos)
	ImGui.SetNextWindowSize(panel_size)
	
	ImGui.Begin("Asset Preview", [], window_flags)
	ImGui.End()

func import_scene(path: String):
	var file = FileAccess.open(path, FileAccess.READ)

	if file:
		var buffer = FileBuffer.new(file.get_buffer(file.get_length()))

		var scene_reader = SceneReader.new(buffer)
		scene_reader.read_scene()

		file.close()
	else:
		print("File could not be opened.")
		
func import_gizmo(path: String):
	var file = FileAccess.open(path, FileAccess.READ)

	if file:
		var buffer = FileBuffer.new(file.get_buffer(file.get_length()))

		var giz_reader = GizReader.new(buffer)
		var gizmos = giz_reader.read_giz()
		for i in gizmos:
			get_node("worldScene").add_child(i)
		file.close()
	else:
		print("File could not be opened.")

func import_spline(path: String):
	var file = FileAccess.open(path, FileAccess.READ)

	if file:
		var buffer = FileBuffer.new(file.get_buffer(file.get_length()))

		var spline_reader = SplineReader.new(buffer)
		var splines = spline_reader.read_spline()
		for i in splines:
			get_node("worldScene").add_child(i)
		file.close()
	else:
		print("File could not be opened.")
