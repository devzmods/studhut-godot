extends Node3D

var show_window: bool = true
var current_project: Project


func _process(_delta: float) -> void:
	if not show_window: return

	var is_open: Array = [show_window]
	
	ImGui.Begin("Project", is_open, ImGui.WindowFlags_MenuBar)

	if ImGui.BeginMenuBar(): # main menubar
		if ImGui.BeginMenu("File"):
			if ImGui.MenuItem("New Project.."): pass
			if ImGui.MenuItem("Open Project.."): pass
			if ImGui.MenuItem("Save Project.."): pass
			if ImGui.MenuItem("Import Scene.."): 
				var file_dialog: FileDialog = FileDialog.new()

				file_dialog.access = FileDialog.ACCESS_FILESYSTEM
				file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
				file_dialog.filters = ["*.gsc ; TTGames Scene File"]
				file_dialog.use_native_dialog = true
				file_dialog.current_dir = OS.get_environment("HOME") + "/Downloads"

				file_dialog.file_selected.connect(import_scene)

				add_child(file_dialog)

				file_dialog.popup_centered()
			if ImGui.MenuItem("Import Giz File.."): 
				var file_dialog: FileDialog = FileDialog.new()

				file_dialog.access = FileDialog.ACCESS_FILESYSTEM
				file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
				file_dialog.filters = ["*.giz ; TTGames Gizmo File"]
				file_dialog.use_native_dialog = true
				file_dialog.current_dir = OS.get_environment("HOME") + "/Downloads"

				file_dialog.file_selected.connect(import_gizmo)

				add_child(file_dialog)

				file_dialog.popup_centered()
			ImGui.EndMenu()
		ImGui.EndMenuBar()

	if ImGui.TreeNode("Gizmos"): # Gizmos list
		if ImGui.Selectable("Gizmo 1"): pass
		ImGui.TreePop()
	
	# ImGui.PopFont()

	ImGui.End()

	show_window = is_open[0]

func import_scene(path: String):
	var file = FileAccess.open(path, FileAccess.READ)

	if file:
		var buffer = file.get_buffer(file.get_length())

		var scene_reader = SceneReader.new(buffer)
		scene_reader.read_scene()

		file.close()
	else:
		print("File could not be opened.")
		
func import_gizmo(path: String):
	var file = FileAccess.open(path, FileAccess.READ)

	if file:
		var buffer = file.get_buffer(file.get_length())

		var giz_reader = GizReader.new(buffer)
		giz_reader.read_giz()

		file.close()
	else:
		print("File could not be opened.")
