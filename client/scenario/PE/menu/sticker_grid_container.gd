extends GridContainer

func _ready() -> void:
	var stickerDir = DirAccess.open("res://client/sticker/")
	if stickerDir:
		stickerDir.list_dir_begin()
		var file_name = stickerDir.get_next()
		while file_name != "":
			if stickerDir.current_is_dir():
				pass
			else:
				if file_name.ends_with(".import"):
					var sticker = load("res://client/scenario/PE/menu/sticker.tscn").instantiate()
					sticker.stickerID = file_name.trim_suffix(".import")
					add_child(sticker)
					sticker.setup()
					
					
			file_name = stickerDir.get_next()
	else:
		print("尝试访问路径时出错。")
