extends Node

#ui
signal ui_opened(ui_name)
signal ui_closed(ui_name)

#game
signal life_updated(life)
signal score_updated(score)
signal game_resumed
