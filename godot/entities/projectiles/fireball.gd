extends Node2D

@export var rotation_fps : float = 14.0

@onready var sprite = $Sprite2D
@onready var hitbox = $HitBox
@onready var trail = %Trail

var time_elapsed : float = 0.0
var impact_position := Vector2.ZERO
var impacted : bool = false


func _ready() -> void:
	hitbox.detected.connect(_on_hitbox_detected)

func _process(delta: float) -> void:
	time_elapsed += delta
	if time_elapsed >= get_rotation_interval():
		rotate_sprite()
		time_elapsed = 0.0
	# always maintain zero rotation
	global_rotation = 0.0
	if impacted:
		global_position = impact_position

func rotate_sprite():
	sprite.rotate(-PI/2)

func get_rotation_interval():
	return 1.0 / rotation_fps

func _on_hitbox_detected(_hurtbox : HurtBox) -> void:
	impact()

func impact() -> void:
	impact_position = global_position
	impacted = true
	sprite.hide()
	await get_tree().create_timer(trail.lifetime).timeout
	queue_free()
