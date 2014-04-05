user = require '../models/user'

login = (data, socket, done) ->
	user.byUserName data.userName , (err, resp) ->
		if not resp
			utils.getUserId data.token, (err, resp) ->
				data.userId = resp.userId
				data.token = resp.longToken
				user.add data, (err, resp) ->
				#get All checked In places and populate
					utils.populateLocations data.token, (err, resp) ->
						done err, resp