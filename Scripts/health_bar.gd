extends ProgressBar

@onready var damage_bar = $Damage_Bar
@onready var timer = $Damage_Bar/Timer

var health = 0 : set = _set_health
var removed = false

func _set_health(new_health):
	var prev_health = health
	health = min(max_value, new_health)
	value = health
	
	if health <= 0:
		removed = true
		queue_free()
	if health < prev_health:
		timer.start()
		print("updated")
	else:
		damage_bar.value = health


func init_Health(_health):
	health = _health
	max_value = health
	value = health
	damage_bar.max_value = health
	damage_bar.value = health


func _on_timer_timeout() -> void:
	damage_bar.value = health
