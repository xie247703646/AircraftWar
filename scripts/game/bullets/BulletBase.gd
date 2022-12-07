extends Area2D
class_name BulletBase

export var fly_speed:float = 800
export var atk:int = 1

onready var visibility_notifier:VisibilityNotifier2D = $VisibilityNotifier2D

func _ready() -> void:
	connect("area_entered",self,"_on_area_entered")
	visibility_notifier.connect("screen_exited",self,"_on_screen_exited")

func _physics_process(delta: float) -> void:
	global_position.y += fly_speed * delta

func _on_area_entered(area:Area2D)->void:
	queue_free()

func _on_screen_exited()->void:
	queue_free()
