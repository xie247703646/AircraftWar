extends Area2D
class_name EnemyBase

export var life:int = 1
export var fly_speed:float = 200
export var score:int = 50
export(AudioStreamSample) var stream_die

onready var anim_sprite:AnimatedSprite = $AnimatedSprite
onready var collision:CollisionPolygon2D = $CollisionPolygon2D
onready var visibility_notifier:VisibilityNotifier2D = $VisibilityNotifier2D

func _ready() -> void:
	add_to_group("Enemy")
	collision.disabled = true
	anim_sprite.connect("animation_finished",self,"_on_anim_finished")
	visibility_notifier.connect("screen_entered",self,"_on_screen_entered")
	visibility_notifier.connect("screen_exited",self,"_on_screen_exited")
	connect("area_entered",self,"_on_area_hit")

func _physics_process(delta: float) -> void:
	global_position.y += fly_speed * delta

func hurt(damage:int)->void:
	life -= damage
	if not is_alive():
		GameMgr.add_score(score)
		disconnect("area_entered",self,"_on_area_hit")
		AudioMgr.play_sound_by_stream(stream_die)
		die()
	else:
		anim_sprite.play("hurt")

func die()->void:
	set_physics_process(false)
	collision.set_deferred("disabled",true)
	anim_sprite.play("die")

func is_alive()->bool:
	return life > 0

func _on_area_hit(area:Area2D)->void:
	var damage:int = area.atk
	hurt(damage)

func _on_anim_finished()->void:
	match anim_sprite.animation:
		"die": queue_free()
		"hurt": anim_sprite.play("idle")

func _on_screen_entered()->void:
	collision.disabled = false

func _on_screen_exited()->void:
	queue_free()
