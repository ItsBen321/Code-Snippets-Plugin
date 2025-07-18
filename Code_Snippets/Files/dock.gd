@tool
extends Control

@onready var codebox: CodeEdit = $VSplitContainer/ScrollContainer2/CodeEdit
@onready var tabs: TabContainer = $VSplitContainer/TabContainer

var save_path = "res://addons/Code_Snippets/Files/settings.save"
var Scripts: Dictionary
var Settings: Dictionary
var CurrentScript: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	LoadDirs()
	LoadMenu()

func Button_Pressed(TheButton):
	var GetScript = FileAccess.get_file_as_string(Scripts[TheButton])
	CurrentScript = Scripts[TheButton]
	codebox.text = GetScript
	DisplayServer.clipboard_set(GetScript)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func LoadDirs():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		var SettingsText = file.get_line()
		file.close()
		var SettingsJson = JSON.new()
		var error = SettingsJson.parse(SettingsText)
		Settings = SettingsJson.data
		
func LoadMenu():
	Scripts.clear()
	codebox.add_theme_font_size_override("font_size", Settings["FontSize"])
	
	for child in tabs.get_children():
		tabs.remove_child(child)
		child.queue_free()
	
	for Dir in Settings["Paths"]:
		var TheName = Dir.get_file()
		var Ext = "."+Settings["Extension"]
		
		var Scroll = ScrollContainer.new()
		Scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
		Scroll.name = TheName
		tabs.add_child(Scroll)
		var vbox = VBoxContainer.new()
		vbox.clip_contents = true
		vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		vbox.size_flags_vertical = Control.SIZE_EXPAND_FILL
		Scroll.add_child(vbox)
		
		var FileArray := DirAccess.get_files_at(Dir)
		for file in FileArray:
			if file.ends_with(Ext):
				var newbutton := Button.new()
				vbox.add_child(newbutton)
				newbutton.text = str(file.trim_suffix(Ext))
				newbutton.pressed.connect(Button_Pressed.bind(newbutton))
				Scripts[newbutton] = Dir + "/" + file

func Reload():
	LoadDirs()
	LoadMenu()


func _on_button_pressed() -> void:
	var TheScript = load(CurrentScript)
	EditorInterface.edit_script(TheScript)
