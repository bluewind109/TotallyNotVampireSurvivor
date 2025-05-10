extends Area2D
class_name Projectile

@export var trail_particle: GPUParticles2D

var direction: Vector2 = Vector2.RIGHT
var speed: float = 200
var damage: float = 1
var knockback: float = 20.0
var pierce_strength: int = 1
var crit_chance: float = 0
var crit_dmg: float = 0

var pierce_count: int = 0 ## Number of enemies that have interacted with the projectile

func init_projectile(
	_position: Vector2, 
	# _direction: Vector2,
	_rotation: float,
	_speed: float, 
	_damage: float,
	_kb_strength: float,
	_pierce_str: int,
	_crit_chance: float,
	_crit_dmg: float
):
	# print("init_projectile")
	position = _position
	direction = Vector2.RIGHT.rotated(_rotation)
	speed = _speed
	damage = _damage
	knockback = _kb_strength
	pierce_strength = _pierce_str
	crit_chance = _crit_chance
	crit_dmg = _crit_dmg

	# rotation = _rotation
	look_at(position + direction)

func _physics_process(delta: float) -> void:
	# print("[Profile] speed: ", speed)
	position += direction * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body is Enemy:
		# print("[projectile] _on_body_entered: ", damage)
		body = body as Enemy

		# check if crit could be applied
		var is_crit = randf() <= crit_chance
		var final_damage: float = damage
		if (is_crit):
			final_damage = damage + damage * crit_dmg

		body.take_damage(final_damage, is_crit)
		body.add_knockback(direction, knockback) # stronger knockback effect
		pierce_count += 1
		if (pierce_count >= pierce_strength): queue_free()

func _on_screen_exited() -> void:
	queue_free()
