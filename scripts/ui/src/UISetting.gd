extends UIBase
class_name UISetting

onready var cb_music: CheckBox = $Panel/VBoxContainer/HFlowContainer/CbMusic
onready var cb_sound: CheckBox = $Panel/VBoxContainer/HFlowContainer2/CbSound

onready var sld_music: HSlider = $Panel/VBoxContainer/HFlowContainer/SLDMusic
onready var sld_sound: HSlider = $Panel/VBoxContainer/HFlowContainer2/SLDSound

onready var btn_close: Button = $Panel/HBoxContainer/BtnClose
onready var btn_back: Button = $Panel/HBoxContainer/BtnBack

var is_sld_music_dragging:bool = false
var is_sld_sound_dragging:bool = false

func on_open(data):
	cb_music.pressed = not AudioMgr.is_music_muted()
	cb_sound.pressed = not AudioMgr.is_sound_muted()
	sld_music.value = AudioMgr.get_music_volume()
	sld_sound.value = AudioMgr.get_sound_volume()
	cb_music.connect("toggled",self,"_on_CbMusic_toggled")
	cb_sound.connect("toggled",self,"_on_CbSound_toggled")
	sld_music.connect("drag_ended",self,"_on_SLDMusic_drag_ended")
	sld_sound.connect("drag_ended",self,"_on_SLDSound_drag_ended")
	sld_music.connect("drag_started",self,"_on_SLDMusic_drag_started")
	sld_sound.connect("drag_started",self,"_on_SLDSound_drag_started")
	sld_music.connect("value_changed",self,"_on_SLDMusic_value_changed")
	sld_sound.connect("value_changed",self,"_on_SLDSound_value_changed")
	btn_close.text = "继续游戏" if GameMgr.is_in_game() else "关闭"
	btn_back.visible = GameMgr.is_in_game()

func on_close(data):
	ConfigMgr.save()
	if GameMgr.is_in_game(): GameMgr.resume_game()

func _on_BtnClose_pressed() -> void:
	close()

func _on_BtnHelp_pressed() -> void:
	UIMgr.open_ui(UI.UIHelp)

func _on_CbMusic_toggled(button_pressed: bool) -> void:
	AudioMgr.set_music_mute(not button_pressed)

func _on_CbSound_toggled(button_pressed: bool) -> void:
	AudioMgr.set_sound_mute(not button_pressed)

func _on_SLDMusic_drag_started() -> void:
	is_sld_music_dragging = true

func _on_SLDSound_drag_started() -> void:
	is_sld_sound_dragging = true

func _on_SLDMusic_drag_ended(value_changed: bool) -> void:
	is_sld_music_dragging = false
	if not value_changed: return
	var value = sld_music.value
	var is_muted = value == AudioMgr.MIN_VOLUME
	cb_music.pressed = not is_muted
	AudioMgr.set_music_volume(value)
	AudioMgr.set_music_mute(is_muted)

func _on_SLDSound_drag_ended(value_changed: bool) -> void:
	is_sld_sound_dragging = false
	if not value_changed: return
	var value = sld_sound.value
	var is_muted = value == AudioMgr.MIN_VOLUME
	cb_sound.pressed = not is_muted
	AudioMgr.set_sound_volume(value)
	AudioMgr.set_sound_mute(is_muted)

func _on_SLDMusic_value_changed(value: float) -> void:
	var is_muted = value == AudioMgr.MIN_VOLUME
	var save = not is_sld_music_dragging
	cb_music.pressed = not is_muted
	AudioMgr.set_music_mute(is_muted,save)
	AudioMgr.set_music_volume(value,save)

func _on_SLDSound_value_changed(value: float) -> void:
	var is_muted = value == AudioMgr.MIN_VOLUME
	var save = not is_sld_sound_dragging
	cb_sound.pressed = not is_muted
	AudioMgr.set_sound_mute(is_muted,save)
	AudioMgr.set_sound_volume(value,save)

func _on_BtnBack_pressed() -> void:
	AudioMgr.stop_music()
	close()
	GameMgr.game_over()
