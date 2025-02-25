extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
@onready var detection_area = $Detection_Areas

const SPEED = 150.0
const JUMP_VELOCITY = -250.0
var Health = 30
var gravity = 10
var target_position = Vector2(0, 0)
var player = null
var chase = false
var attack_range = false
var player_vulnerable = null
var attacking = false
var attacked = false
var hurt = false
#func _ready():
	#collision_layer = 1 << 2  # "Enemies" layer is the 3rd layer
	#collision_mask = ~(1 << 2)  # Invert the mask to exclude the "Enemies" layer
	
func _physics_process(delta: float) -> void:
	# Add gravity

	velocity += get_gravity() * delta
	attacking = false
	attacked = false
	if chase:
		target_position = player.position
		var direction = target_position - global_position
		direction = direction.normalized()
		"""if in_range:
			target_position = player.position - Vector2(11, 0)
			getting_attacked = player_damage.return_attacking()
			if getting_attacked:
				pass
		if vulnerable_area:
			if not is_attacking:
				sprite.play("idle")
			velocity.x = 0
			timer_3.start()"""
			
		
			#target_position = player.position - Vector2(11, 0)

		sprite.flip_h = direction.x > 0
			
			
			
		
			#target_position = player.position + Vector2(11, 0)
		sprite.flip_h = direction.x < 0
			
		
		velocity.x = direction.x * SPEED
		
		sprite.play("walking")
	
		
		
	elif attack_range:
		target_position = player_vulnerable.position
		if player_vulnerable.has_method("ReturnAttacking"):
			attacked = player_vulnerable.ReturnAttacking()
		var direction = target_position - global_position
		direction = direction.normalized()
		if direction.x > 0:
			target_position = player_vulnerable.position - Vector2(11, 0)
			sprite.flip_h = false
			
			
			
		elif direction.x < 0:
			target_position = player_vulnerable.position + Vector2(11, 0)
			sprite.flip_h = true
		if Health <= 0:
			Health = 0
			sprite.play("death")
			
		elif attacked:
			sprite.play("hurt")
			Health -= 10
			print(Health, "goblin")
			hurt = true
		if not attacked and not hurt:
			sprite.play("attack_one")
		
		velocity.x = 0
		
	
	else:
		velocity.x = 0
		sprite.play("idle")
	
		

	# Apply movement
	move_and_slide()



	
	


func _on_detection_area_body_entered(body: Node2D) -> void:
	player = body
	chase = true
	print("entered chase range")

func _on_detection_area_body_exited(body: Node2D) -> void:
	player = null
	chase = false
	print("left chase range")


func _on_attack_area_body_entered(body: Node2D) -> void:
	player_vulnerable = body
	attack_range = true
	print("entered attack range")

func _on_attack_area_body_exited(body: Node2D) -> void:
	player_vulnerable = null
	attack_range = false
	print("left attack range")


func _on_animated_sprite_2d_animation_finished() -> void:
	if sprite.animation == "attack_one":
		attacking = true
	if sprite.animation == "hurt":
		attacked = false
		hurt = false
	if sprite.animation == "death":
		queue_free()
func _on_animated_sprite_2d_animation_looped() -> void:
	if sprite.animation == "attack_one":
		attacking = true
	if sprite.animation == "hurt":
		attacked = false
		hurt = false
	if sprite.animation == "death":
		queue_free()
func return_attacks():
	return attacking


	
