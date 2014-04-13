user = require '../models/user'
utils = require './utils'
qdb = require '../models/qa'
async = require 'async'


module.exports = {
	login : (socket, data, done) ->	
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
								utils.populateLocations socket, re._id, data.token
								return done null, re
						else
							utils.populateLocations socket, res._id, data.token
							return done null, res
			else
				return done err

	find : (ids, done) ->
		user.getUserByIdInArray ids, (err, resp) ->
			if err?
				return done err
			else
				async.map resp, (res, callback) ->
					qdb.getQuestionForUser res._id, (err, qresp) ->
						res = res.toJSON()
						if not err?
							res.questions = []
							for question in qresp
								res.questions.push question._id
							callback null, res
						else
							callback err
				,
				(err, results)->
					return done null, results
}
