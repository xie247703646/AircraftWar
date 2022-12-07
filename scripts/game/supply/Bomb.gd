extends SupplyBase
class_name Bomb

var fx_scene:PackedScene = preload("res://scenes/game/fx/FxBombExplosion.tscn")

func _execute()->void:
	AudioMgr.play_sound("use_bomb")
	get_tree().call_group("Enemy","die")
	get_tree().call_group("EnemyBullet","queue_free")
	GameMgr.play_fx(fx_scene,Vector2.ZERO)
