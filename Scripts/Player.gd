extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -270.0
@onready var sprite = $AnimatedSprite2D
@onready var health_bar = $Camera2D/Health_Bar
@onready var heal_timer = $heal_timer
@onready var mana_bar = $Camera2D/Mana_Bar

var current_animation := "idle"
var Health = 100
var Mana = 100
var Damage = 0
var attacked = false
var enemies = []
var attacked_range = false
var attacking = false
var played_attack = false

func _ready() -> void:
	health_bar.init_Health(Health)
	mana_bar.init_Mana(Mana)
func _physics_process(delta: float) -> void:
	sprite.play(current_animation)
	print("current", current_animation)
	attacked = false
	attacking = false
	print("Player Health: ", Health)
	print("Player Mana: ", Mana)
	if not is_on_floor():
		velocity += get_gravity() * delta
		current_animation = "fall"
	if attacked_range:
		for enemy in enemies:
			if enemy.has_method("return_attacking"):
				attacked = enemy.return_attacking()
				print("dan", enemy.attacking)
			if attacked:
				Health -= 5
				if Health <= 0:
					Health = 0
					print(Health)
					current_animation = "Death"
					health_bar.health = Health
					queue_free()
				else:
					health_bar.health = Health
					current_animation = "hurt"
					print(Health)
		#
	if Input.is_action_just_pressed("ui_left") and Input.is_action_just_pressed("ui_right"):
		current_animation = "idle"
	if Input.is_action_pressed("ui_left") and Input.is_action_pressed("ui_right"):
		current_animation = "idle"
	if Input.is_action_just_released("ui_left"):
		current_animation = "idle"
	if Input.is_action_just_released("ui_right"):
		current_animation = "idle"
		
	if Input.is_action_pressed("ui_left") and not  Input.is_action_pressed("ui_right"):
		sprite.flip_h = true
		current_animation = "walking"
		
	if Input.is_action_pressed("ui_right") and not  Input.is_action_pressed("ui_left"):
		sprite.flip_h = false
		current_animation = "walking"
	
	if velocity.y > 0:
		current_animation = "fall"
		
	
			

		
		
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		current_animation = "jump"
	if Input.is_action_just_pressed("Left_Click") and not Input.is_action_just_pressed("ui_left") and not Input.is_action_pressed("ui_right") and current_animation != "fall" and played_attack == false and Mana >= 100: #and current_animation != "damaged":
		current_animation = "attack_one"
		attacking = true
		played_attack = true
		Damage = 7
	#if Input.is_action_just_released("Left_Click") and not Input.is_action_pressed("ui_left") and not Input.is_action_pressed("ui_right") and current_animation != "fall":
		#current_animation = "idle"
		#ttacking = false
	if Input.is_action_just_pressed("Right_Click") and not Input.is_action_just_pressed("ui_left") and not Input.is_action_pressed("ui_right") and current_animation != "fall" and played_attack == false and Mana >= 20: #and current_animation != "damaged":
		attacking = true
		current_animation = "attack_two"
		played_attack = true
		Damage = 15
	#if Input.is_action_just_released("Right_Click") and not Input.is_action_pressed("ui_left") and not Input.is_action_pressed("ui_right") and current_animation != "fall":
		#current_animation = "idle"
		#attacking = false
	if Input.is_action_just_pressed("Scroll_Wheel") and not Input.is_action_just_pressed("ui_left") and not Input.is_action_pressed("ui_right") and current_animation != "fall" and played_attack == false and Mana >= 30: #and current_animation != "damaged":
		attacking = true
		current_animation = "attack_three"
		played_attack = true
		Damage = 20
	#if Input.is_action_just_released("Scroll_Wheel") and not Input.is_action_pressed("ui_left") and not Input.is_action_pressed("ui_right") and current_animation != "fall":
		#current_animation = "idle"
		#attacking = false
	
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()

func return_health():
	return Health



	
	#print("entered")
	

func _on_animated_sprite_2d_animation_finished() -> void:
	#if current_animation == "attack_one":
		#attacking = true
		#print("player attacking")
	if current_animation == "hurt":
		current_animation = "idle"
	if current_animation == "jump":
		current_animation =  "fall"
	if current_animation == "attack_one":
		Mana -= 10
		mana_bar.mana = Mana
		attacking = true
		current_animation = "idle"
		played_attack = false
		
	if current_animation == "attack_two":
		Mana -= 20
		mana_bar.mana = Mana
		current_animation = "idle"
		attacking = true
		played_attack = false
	if current_animation == "attack_three":
		Mana -= 30
		mana_bar.mana = Mana
		attacking = true
		current_animation = "idle"
		played_attack = false
	#if current_animation == "idle" or "walking" or "jump" or "fall":
		#if Mana != 100:
			#Mana += 1
	if current_animation == "fall":
		if is_on_floor():
			current_animation = "idle"
func _on_animated_sprite_2d_animation_looped() -> void:
	#if current_animation == "attack_one":
		#attacking = true
	if current_animation == "hurt":
		current_animation = "idle"
	if current_animation == "jump":
		current_animation = "fall"
	if current_animation == "attack_one":
		Mana -= 10
		mana_bar.mana = Mana
		current_animation = "idle"
		played_attack = false
		
	if current_animation == "attack_two":
		Mana -= 20
		mana_bar.mana = Mana
		current_animation = "idle"
		
		played_attack = false
	if current_animation == "attack_three":
		Mana -= 30
		mana_bar.mana = Mana
		
		current_animation = "idle"
		played_attack = false
	if current_animation == "idle" or "walking" or "jump" or "fall":
		heal_timer.start()
	if current_animation == "fall":
		if is_on_floor():
			current_animation = "idle"
		
func ReturnAttacking():
	return attacking


func _on_attack_attacked_area_body_entered(body: Node2D) -> void:
	enemies.append(body)
	attacked_range = true	
	print("player_area", enemies)



func _on_attack_attacked_area_body_exited(body: Node2D) -> void:
	enemies = []
	attacked_range = false	


func _on_heal_timer_timeout() -> void:
	if current_animation == "idle" or current_animation == "walking" or current_animation == "jump" or current_animation == "fall":
		if Health != 100:
			Health += 1
			health_bar.health = Health
	if current_animation != "attack_one" or current_animation != "attack_two" or current_animation != "attack_three":
		if Mana != 100:
			Mana += 1
			mana_bar.mana = Mana
