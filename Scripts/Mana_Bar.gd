extends ProgressBar

@onready var Consumption_Bar = $Consumption_Bar
@onready var timer = $Consumption_Bar/Timer

var mana = 0 : set = _set_mana
var removed = false

func _set_mana(new_mana):
	var prev_mana = mana
	mana = min(max_value, new_mana)
	value = mana
	
	
	if mana < prev_mana:
		timer.start()
	else:
		Consumption_Bar.value = mana


func init_Mana(_mana):
	mana = _mana
	max_value = mana
	value = mana
	Consumption_Bar.max_value = mana
	Consumption_Bar.value = mana


func _on_timer_timeout() -> void:
	Consumption_Bar.value = mana
