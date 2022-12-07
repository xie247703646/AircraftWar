extends UIBase
class_name UIMain

onready var title: Label = $Title
onready var main_menu: VBoxContainer = $MainMenu

func on_open(data)->void:
	UIMgr.show_input_block()

	var tw1 = create_tween()
	title.rect_position.y = -100
	tw1.set_trans(Tween.TRANS_BACK)
	tw1.set_ease(Tween.EASE_OUT)
	tw1.tween_property(title,"rect_position:y",70.0,1).set_delay(0.2)
	tw1.play()

	var tw2 = create_tween()
	main_menu.rect_position.y = 1000
	tw2.set_trans(Tween.TRANS_CIRC)
	tw2.set_ease(Tween.EASE_OUT)
	tw2.tween_property(main_menu,"rect_position:y",450.0,0.5).set_delay(0.5)
	tw2.play()

	yield(get_tree().create_timer(0.5),"timeout")
	UIMgr.hide_input_block()


func _on_BtnQuit_pressed() -> void:
	get_tree().quit()


func _on_BtnSetting_pressed() -> void:
	UIMgr.open_ui(UI.UISetting)


func _on_BtnHelp_pressed() -> void:
	UIMgr.open_ui(UI.UIHelp)


func _on_BtnStart_pressed() -> void:
	GameMgr.start_game()
	close()
