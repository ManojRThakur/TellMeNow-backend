user = require '../models/user'
utils = require './utils'

module.exports = {
	login : (data, socket, done) ->	
		utils.getUserId data.token, (err, resp) ->
			if not err?
				data.userId = resp.userId
				data.token = resp.token
				data.userName = resp.userName
				utils.makeUser data , (dbUser) ->
					user.postUserInfo dbUser, (err, resp) ->
					#get All checked In places and populate
						if err?
							return done err
						else
							utils.populateLocations data.userId, data.token
						return done null, resp 
			else
				done err, null
}


login : (data, socket, done) ->
		user.byUserName data.userName , (err, resp) ->
			if not resp? and not err?
				utils.getUserId data.token, (err, resp) ->
					if not err?
						data.userId = resp.userId
						data.token = resp.longToken
						data.userName = resp.userName
						utils.makeUser data , (dbUser) ->
							user.add dbUser, (err, resp) ->
							#get All checked In places and populate
								if err?
									return done err
								else
									utils.populateLocations data.userId, data.token
								return done null, resp 
					else
						done err, null
			else if err 
				done err
			else
				done null, data