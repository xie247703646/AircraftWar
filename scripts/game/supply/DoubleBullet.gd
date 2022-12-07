extends SupplyBase
class_name DoubleBullet

export var duration:int = 5

func _execute()->void:
	AudioMgr.play_sound("get_double_bullet")
	player.change_shoot_mode(Enum.ShootMode.Double)
	var timer:Timer = player.get_node_or_null("DoubleBulletTimer")
	if not timer:
		timer = Timer.new()
		timer.name = "DoubleBulletTimer"
		if not timer.is_connected("timeout",self,"change_shoot_mode"):
			timer.connect("timeout",player,"change_shoot_mode",[Enum.ShootMode.Single])
		timer.call_deferred("start",duration)
		player.add_child(timer)
	else:
		timer.start(duration)
