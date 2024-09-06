extends Area2D

@onready var sprite = $"../AnimatedSprite2D"
# Called when the node enters the scene tree for the first time.
var default_position = 0

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if sprite.flip_h == true:
		position.x = -27
	if sprite.flip_h == false:
		position.x = default_position
