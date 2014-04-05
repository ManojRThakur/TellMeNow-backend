var FB = require('fb');

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

populateLocations = (userId, token) -> 
	var FB = require('fb')
	FB.setAccessToken(token)

	FB.api '/#{userId}/locations', (res) ->
	  	if not res? or res.error?
	   		console.log 'Could not find any checkins'
	  
	  	if res.data? and res.data.length > 0	
	    	for data in  res.data
	    		if res.data.place?
