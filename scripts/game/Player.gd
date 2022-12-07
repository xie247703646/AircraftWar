extends Area2D
class_name Player

var bullet_scene_1:PackedScene = preload("res://scenes/game/bullet/PlayerBullet.tscn")
var fx_be_attaked:PackedScene = preload("res://scenes/game/fx/FxBeAttacked.tscn")
onready var collision_polygon_2d: CollisionPolygon2D = $CollisionPolygon2D
onready var animated_sprite: AnimatedSprite = $AnimatedSprite
onready var muzzle1: Position2D = $Muzzle1
onready var muzzle2: Position2D = $Muzzle2
onready var muzzle3: Position2D = $Muzzle3
onready var shoot_timer: Timer = $ShootTimer

export var life:int = 3
export var atk:int = 999
export(Enum.ShootMode) var shoot_mode:int = Enum.ShootMode.Single

var _is_dragging:bool = false
var _drag_offset:Vector2 = Vector2.ZERO

func _ready() -> void:
	pass

func start_shoot()->void:
	shoot_timer.start()

func _physics_process(delta: float) -> void:
	if not _is_dragging: return
	if not is_alive(): return
	global_position = get_global_mouse_position() + _drag_offset
	global_position.x = clamp(global_position.x,0,OS.window_size.x)
	global_position.y = clamp(global_position.y,0,OS.window_size.y)

func _hurt(damage:int)->void:
	life -= damage
	SignalMgr.emit_signal("life_updated",life)
	if not is_alive(): _die()
	else: GameMgr.play_fx(fx_be_attaked,Vector2.ZERO)

func _die()->void:
	GameMgr.is_game_over = true
	AudioMgr.play_sound("game_over")
	AudioMgr.stop_music()
	UIMgr.show_input_block()
	shoot_timer.stop()
	collision_polygon_2d.set_deferred("disabled",true)
	Engine.time_scale = 0.4
	animated_sprite.connect("animation_finished",self,"_on_died",[],CONNECT_ONESHOT)
	animated_sprite.play("die")

func is_alive()->bool:
	return life > 0

func _on_died()->void:
	Engine.time_scale = 1
	yield(get_tree().create_timer(1),"timeout")
	GameMgr.game_over()
	UIMgr.hide_input_block()

func _create_bullet(bullet_scene:PackedScene,muzzle:Position2D)->void:
	var bullet_ins:PlayerBullet = bullet_scene.instance()
	GameMgr.get_bullet_container().add_child(bullet_ins)
	bullet_ins.global_position = muzzle.global_position

func change_shoot_mode(mode:int)->void:
	shoot_mode = mode

func _on_ShootTimer_timeout() -> void:
	#创建子弹
	match shoot_mode:
		Enum.ShootMode.Single:
			_shoot_single()
		Enum.ShootMode.Double:
			_shoot_double()

func _shoot_single()->void:
	_create_bullet(bullet_scene_1,muzzle1)
	AudioMgr.play_sound("bullet")

func _shoot_double()->void:
	_create_bullet(bullet_scene_1,muzzle2)
	_create_bullet(bullet_scene_1,muzzle3)
	AudioMgr.play_sound("bullet")

func _on_Player_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		_drag_offset = global_position - get_global_mouse_position()
		_is_dragging = event.is_pressed()

func _on_Player_area_entered(area: Area2D) -> void:
	var groups = area.get_groups()
	if "Enemy" in groups or "EnemyBullet" in groups:
		_hurt(1)
