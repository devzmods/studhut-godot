extends Node
class_name TextReader

var text: String

var properties: Dictionary = {}

func _init(file_text: String) -> void:
	text = file_text

func read_text() -> void:
	pass