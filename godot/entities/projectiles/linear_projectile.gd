class_name LinearProjectile
extends CharacterBody2D

@onready var sprite = $Sprite2D
@onready var shadow = $Shadow
@onready var hitbox = $HitBox
@onready var collision_shape = $CollisionShape2D2

var move_direction = Vector2.RIGHT
var move_speed = 100


func _ready() -> void:
	hitbox.detected.connect(_on_hitbox_detected)

func _process(delta: float) -> void:
	velocity = move_direction * move_speed
	point_toward_move_direction()
	move_and_slide()
	if get_kinematic_collider(delta):
		impact()

func _on_hitbox_detected(_hurtbox : HurtBox) -> void:
	impact()

func impact() -> void:
	velocity = Vector2.ZERO
	queue_free()

func point_toward_move_direction() -> void:
	var r = move_direction.angle()
	sprite.rotation = r
	shadow.rotation = r
	hitbox.rotation = r
	var hitbox_trans = hitbox.get_collision_shape().global_transform
	collision_shape.global_transform = hitbox_trans

func get_kinematic_collider(delta : float) -> Object:
	var collider : Object = move_and_collide(velocity * delta, true)
	return collider
