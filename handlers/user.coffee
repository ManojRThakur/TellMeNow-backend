user = require '../models/user'
utils = require './utils'

module.exports = {
	login : (data, done) ->	
		utils.getUserId data.token, (err, resp) ->
			if not err?
				data.userId = resp.userId
				data.token = resp.token
				data.userName = resp.userName
				utils.makeUser data , (dbUser) ->
					user.postUserInfoByFacebookId dbUser.facebookId, dbUser, (err, res) ->
						return done err if err?
						if not res
							user.postUserInfo dbUser, (err, re) ->
								return done err if err?
								utils.populateLocations re._id, data.token
								return done null, re
						else
							utils.populateLocations res._id, data.token
							return done null, res
			else
				return done err
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