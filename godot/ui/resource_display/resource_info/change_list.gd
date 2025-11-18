extends PanelContainer

@onready var change_label : Label = %ChangeLabel

var fade_tween : Tween
var fade_time = 1.0


func fade_text() -> void:
	if fade_tween : fade_tween.kill()
	fade_tween = create_tween()
	fade_tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
	fade_tween.tween_property(change_label, "modulate:a", 0.0, fade_time)

func accumulate(value : int) -> void:
	change_label.text = "%+d" % value
	change_label.modulate.a = 1.0
	fade_text()
