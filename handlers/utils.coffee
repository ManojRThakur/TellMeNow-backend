sendError = (socket, data) ->
	resp = {}
	resp.type = 'error'
	resp.info = data
	socket.emit resp

sendSuccess = (socket, data) ->
	resp = {}
	resp.type = 'success'
	resp.info = data
	socket.emit resp
