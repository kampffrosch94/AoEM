class Logger:
	var logfile
	var enabledloglevels
	const debug = 0
	const trace = 1
	const warning = 2
	const info = 3
	const error = 4
	func _init():
		logfile = File.new()
		logfile.open("res://log.txt",File.WRITE)
		enabledloglevels = [debug,trace,warning,info,error]
	func _destroy():
		logfile.close()
	
	func baselog(tag,line,echo,type):
		if enabledloglevels.find(type) != -1:
			var towrite = tag+" | " + line 
			logfile.store_line(towrite)
			if echo:
				print(towrite)

	func d(tag, line, echo=false):
		var towrite = "debug|"+tag 
		baselog(tag,line,echo,debug)
	
	func t(tag, line, echo=false):
		var towrite = "trace|"+tag 
		baselog(tag,line,echo,trace)
	
	func w(tag, line, echo=false):
		var towrite = "warning|"+tag
		baselog(tag,line,echo,warning)
	
	func i(tag, line, echo=false):
		var towrite = "info|"+tag 
		baselog(tag,line,echo,info)
	
	func e(tag, line, echo=false):
		var towrite = "ERROR|"+tag 
		baselog(tag,line,echo,error)
	
	func te(tag,line,echo = true):
		t(tag,line,echo)

	func de(tag,line,echo = true):
		d(tag,line,echo)

	func we(tag,line,echo = true):
		w(tag,line,echo)

	func ee(tag,line,echo = true):
		e(tag,line,echo)

	func ie(tag,line,echo = true):
		i(tag,line,echo)
