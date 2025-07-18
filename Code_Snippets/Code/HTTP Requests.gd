func Request_Completed(Result: int, Code: int, ServerHeaders: PackedStringArray, Body: PackedByteArray) -> void:
	var json = JSON.new()
	var error = json.parse(Body.get_string_from_utf8())
	var New_Data = json.data
