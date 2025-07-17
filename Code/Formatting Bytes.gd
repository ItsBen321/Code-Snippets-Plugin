func format_bytes(bytes: int) -> String:
	# Single-byte or negative edge-cases
	if bytes < 1024 and bytes > -1024:
		return str(bytes) + "B"
	
	var units := ["KB", "MB", "GB", "TB", "PB", "EB"]
	var value := float(bytes)
	var i := 0
	while abs(value) >= 1024.0 and i < units.size():
		value /= 1024.0
		i += 1
	
	# Clamp index in case the number is *really* huge
	i = clamp(i - 1, 0, units.size() - 1)
	
	return "%0.2f" % value + " " + units[i]
