extends Area2D
class_name SupplyBase

export var fly_speed:float = 150

onready var visibility_notifier_2d: VisibilityNotifier2D = $VisibilityNotifier2D
onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var player:Player

func _ready() -> void:
	collision_shape_2d.set_deferred("disabled",true)
	connect("area_entered",self,"_on_area_entered",[],CONNECT_ONESHOT)
	visibility_notifier_2d.connect("screen_entered",self,"_on_screen_entered",[],CONNECT_ONESHOT)
	visibility_notifier_2d.connect("screen_exited",self,"_on_screen_exited",[],CONNECT_ONESHOT)

func _physics_process(delta: float) -> void:
	global_position.y += fly_speed * delta

func _execute()->void:
	pass

func _on_screen_entered()->void:
	collision_shape_2d.set_deferred("disabled",false)

func _on_screen_exited()->void:
	collision_shape_2d.set_deferred("disabled",true)
	queue_free()

func _on_area_entered(area:Area2D)->void:
	player = area
	_execute()
	queue_free()
