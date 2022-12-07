extends UIOpenAnim
class_name ScaleOpen

func play()->void:
	.play()
	ui.rect_scale = Vector2.ZERO
	var tw = create_tween()
	tw.set_trans(Tween.TRANS_BACK)
	tw.set_ease(Tween.EASE_OUT)
	tw.tween_property(ui,"rect_scale",Vector2.ONE,duration)
	tw.tween_callback(self,"_on_anim_finished")
	tw.play()
