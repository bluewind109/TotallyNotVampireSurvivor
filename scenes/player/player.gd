extends CharacterBody2D

var speed: float = 150.0
var health: float = 100.0:
	set(value):
		health = value
		%Health.value = value
		
var nearest_enemy: CharacterBody2D
var nearest_enemy_distance: float = INF
var a: float

func _physics_process(delta):
	if (is_instance_valid(nearest_enemy)):
		nearest_enemy_distance = nearest_enemy.separation
		#print(nearest_enemy.name)
	else:
		nearest_enemy_distance = INF
	
	velocity = Input.get_vector("left", "right", "up", "down") * speed # velocity calc
	move_and_collide(velocity * delta) # move & collide with that velocity

func take_damage(amount):
	health -= amount
	print("take_damage: ", amount)

func _on_self_damage_body_entered(body: Node2D) -> void:
	take_damage(body.damage)


func _on_timer_timeout() -> void:
	%Collision.set_deferred("disabled", true)
	%Collision.set_deferred("disabled", false)
