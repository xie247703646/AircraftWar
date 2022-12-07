extends EnemyBase

var bullet_scene:PackedScene = preload("res://scenes/game/bullet/EnemyBullet.tscn")

onready var shoot_timer: Timer = $ShootTimer
onready var muzzle: Position2D = $Muzzle

func die()->void:
	.die()
	shoot_timer.stop()

func _on_screen_entered()->void:
	._on_screen_entered()
	shoot_timer.start()

func _on_ShootTimer_timeout() -> void:
	var bullet_ins:EnemyBullet = bullet_scene.instance()
	GameMgr.get_bullet_container().add_child(bullet_ins)
	bullet_ins.global_position = muzzle.global_position
