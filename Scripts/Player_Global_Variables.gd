extends Node

@onready var player = $".."
var Health = null

func _process(delta: float) -> void:
	Health = player.Health
