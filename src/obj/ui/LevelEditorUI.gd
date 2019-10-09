extends Control

export(NodePath) var Level

func _ready():
	pass

func _on_RegenButton_pressed():
	get_tree().reload_current_scene()
