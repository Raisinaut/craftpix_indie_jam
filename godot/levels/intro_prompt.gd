extends Label


func _ready() -> void:
	get_tree().create_timer(4.0).timeout.connect(queue_free)
