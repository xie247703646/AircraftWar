extends UIBase
class_name UIGame

onready var lb_life: Label = $HBoxContainer/LbLife
onready var lb_score: Label = $LbScore
onready var btn_pause: TextureButton = $BtnPause

var _show_score:int = 0
var _cur_score:int = 0

func on_open(data):
	SignalMgr.connect("life_updated",self,"_on_life_updated")
	SignalMgr.connect("score_updated",self,"_on_score_updated")
	SignalMgr.connect("game_resumed",self,"_on_game_resumed")

func on_close(data):
	SignalMgr.disconnect("life_updated",self,"_on_life_updated")
	SignalMgr.disconnect("score_updated",self,"_on_score_updated")
	SignalMgr.disconnect("game_resumed",self,"_on_game_resumed")

func _physics_process(delta: float) -> void:
	if _show_score == _cur_score: return
	_cur_score += 5
	lb_score.text = "Score:" + String(_cur_score)

func _on_life_updated(life:int)->void:
	lb_life.text = String(life)

func _on_score_updated(score:int)->void:
	_show_score = score

func _on_game_resumed()->void:
	btn_pause.pressed = false

func _on_BtnPause_pressed() -> void:
	UIMgr.open_ui(UI.UISetting)
	GameMgr.pause_game()
