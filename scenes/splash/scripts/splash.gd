extends Node

func _ready() -> void:
	get_window().size = Vector2(800, 400)
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_RESIZE_DISABLED, true)
	get_window().title = "Welcome to Studhut!"

func _process(_delta: float) -> void:
	var viewport: Rect2 = get_viewport().get_visible_rect()
	var window_flags: int = ImGui.WindowFlags_NoMove | ImGui.WindowFlags_NoResize | ImGui.WindowFlags_NoCollapse | ImGui.WindowFlags_NoDecoration

	var panel_width: float = viewport.size.x * 0.2

	ImGui.SetNextWindowSize(Vector2(panel_width, viewport.size.y))
	ImGui.SetNextWindowPos(Vector2(0, 0))
	ImGui.Begin("Menu", [], window_flags)
	if ImGui.Selectable("Projects"): pass
	ImGui.End()

	panel_width = viewport.size.x * 0.8

	ImGui.SetNextWindowSize(Vector2(panel_width, viewport.size.y))
	ImGui.SetNextWindowPos(Vector2(viewport.size.x * 0.2, 0))
	ImGui.Begin("Projects", [], window_flags)
	ImGui.End()
