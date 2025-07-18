func GetTimeElapsed():
	var TimeStamp: int = Time.get_ticks_msec()
	var Minutes: int = TimeStamp/60000
	var Seconds: int = (TimeStamp-(Minutes*60000)) / 1000
	var MS: int = (TimeStamp-(Minutes*60000))-(Seconds*1000)
	return {"TimeStamp": TimeStamp, "Minutes": Minutes, "Seconds": Seconds, "MS": MS}
