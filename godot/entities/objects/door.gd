extends StaticBody2D

signal fully_opened
signal fully_closed

@onready var sprite = $AnimatedSprite2D


func open():
	sprite.play("open_down")
	await sprite.animation_finished
	fully_opened.emit()

func close():
	sprite.play_backwards("open_down")
	await sprite.animation_finished
	fully_closed.emit()

func is_closed() -> bool:
	return sprite.frame == 0
