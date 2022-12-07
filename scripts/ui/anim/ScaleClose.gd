extends UICloseAnim
class_name ScaleClose

func play()->void:
	.play()
	var tw = create_tween()
	tw.set_trans(Tween.TRANS_BACK)
	tw.set_ease(Tween.EASE_IN)
	tw.tween_property(ui,"rect_scale",Vector2.ZERO,duration)
	tw.tween_callback(self,"_on_anim_finished")
	tw.play()
