extends Node3D

func _process(_delta: float) -> void:
	ImGui.Begin("Hello World")
	ImGui.Text("Hello from ImGui!")
	ImGui.End()
