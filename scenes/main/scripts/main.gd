extends Node3D

var show_window: bool = true
var current_project: Project

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
	if not show_window: return

	var is_open: Array = [show_window]
	

	# --- Main Menu Bar for the entire screen ---
	if ImGui.BeginMainMenuBar():
		if ImGui.BeginMenu("File"):
			if ImGui.MenuItem("New Project.."): pass
			if ImGui.MenuItem("Open Project.."): pass
			if ImGui.MenuItem("Save Project.."): pass
			if ImGui.MenuItem("Import Scene.."):
				_show_file_dialog(["*.gsc ; TTGames Scene File"], import_scene)
			if ImGui.MenuItem("Import Giz File.."):
				_show_file_dialog(["*.giz ; TTGames Gizmo File"], import_gizmo)
			if ImGui.MenuItem("Import Spline File.."):
				_show_file_dialog(["*.spl ; TTGames Spline File"], import_spline)
			ImGui.EndMenu()

	ImGui.EndMainMenuBar()
	
	
	var viewport = get_viewport().get_visible_rect()
	
	var panel_width = viewport.size.x * 0.2
	var menu_bar_height = ImGui.GetFrameHeight()
	var panel_pos = Vector2(0, menu_bar_height)
	var panel_size = Vector2(panel_width, viewport.size.y - menu_bar_height)

	ImGui.SetNextWindowPos(panel_pos)
	ImGui.SetNextWindowSize(panel_size)
	var window_flags = ImGui.WindowFlags_NoMove | ImGui.WindowFlags_NoResize | ImGui.WindowFlags_NoTitleBar | ImGui.WindowFlags_NoCollapse

	ImGui.Begin("Project", is_open, window_flags)
	
	if ImGui.TreeNode("Gizmos"): # Gizmos list
		var children = get_node("worldScene").get_children()
		for child in children:
			if child is GizObstacle:
				if ImGui.Selectable(child.Name): pass
		ImGui.TreePop()
	if ImGui.TreeNode("Images"): # Gizmos list
		var children = get_node("worldScene").get_children()
		for child in children:
			if child is GscTexture:
				if child.ImageTex:
					ImGui.Image(child.ImageTex,Vector2(256,256))
		ImGui.TreePop()
	
	ImGui.End()

	show_window = is_open[0]

func import_scene(path: String):
	var file = FileAccess.open(path, FileAccess.READ)

	if file:
		var buffer = FileBuffer.new(file.get_buffer(file.get_length()))

		var scene_reader = SceneReader.new(buffer)
		var textures = scene_reader.read_scene()
		for i in textures:
			get_node("worldScene").add_child(i)
		file.close()
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
