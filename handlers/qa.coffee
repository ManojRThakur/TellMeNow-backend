qdb = require '../models/qa'
locationsdb = require '../models/location'
notification = require '../models/notification'
subscription = require './subscription'
async = require 'async'
mapping = require './mapping'
utils = require './utils'
comments = require '../models/comments'
followups = require '../models/followup'


module.exports = {
	postQuestion  : (data, socket, done) ->

		qdb.postQuestion data, (err, resp) ->
			if err?
				done err, null
			else
				#subscribe , add in place table 
				async.series [
					(done) ->
						locationsdb.getLocationById resp.place, (err,res) ->
							if not err?
								for user in res.users
									mapping.getMapping user, (socket) ->
										if socket?
											socket.emit '/stream', resp
								done null, resp 
							else
								done err
						#subscription.subscribe resp._id, socket, () ->
						#	console.log 'Entered 1'
						#	done null, resp
					,
					(done) ->
						question = {_id: data.place, questions : resp._id}
						locationsdb.addQuestions question, (err, dataResp) ->
							if err? 
								done err
							else
								done null, dataResp
					,
					(done) ->
						notif = {}
						notif.id = resp._id
						notif.user = resp.user
						notif.type = 'question' 
						notification.postNotification notif, (err, resp) ->
							if err? 
								done err
							else
								done null, resp
				],
				(err, results) ->
					if err? and err.length > 0
						return done err
					else
						return done null, results[0]
				##publish to potential answrers
				## add question in place table 
	,
	getQuestions: (ids, done) ->
		qdb.getQuestionByIdInArray ids, (err, resp) ->
			if err
				return done err
			else
				async.map resp, (res, callback) ->
					qdb.getAnswersByQuestionId res._id, (err, qresp) ->
						res = res.toJSON()
						if not err?
							res.answers = []
							for answer in qresp
								res.answers.push answer._id
							callback null, res
						else
							callback err
				,
				(err, results)->
					async.map results, (res, callback) ->
						comments.getCommentByQuestionId res._id, (err, cresp) ->
							if not err?
								res.comments = []
								for comment in cresp
									res.comments.push comment._id
								callback null, res
							else
								callback err
					,
					(err, results1)->
						return done null, results1
	,
	getAnswers: (ids, userId, done) ->
		qdb.getAnswerByIdInArray ids, (err, resp) ->
			if err
				return done err
			else
				async.map resp, (res, callback) ->
					res = res.toJSON()
					res.rating = res.votesup.length - res.votesdown.length
					if(res.votesup.indexOf userId) is -1
						if(res.votesdown.indexOf userId) is -1
							res.thumbs = 0
						else
							res.thumbs = 2
					else
						res.thumbs = 1
					callback null, res
				,
				(err, results)->
					async.map results, (res, callback) ->
						followups.getFollowUpByAnswerId res._id, (err, cresp) ->
							if not err?
								res.followups = []
								for followup in cresp
									res.followups.push followup._id
								callback null, res
							else
								callback err
					,
					(err, results1)->
						return done null, results1
	,
	postAnswer : (data, socket, done) ->
		qdb.postAnswer data, (err, resp) ->	
			if err
				done err, null
			else
				notif = {}
				notif.id = resp._id
				notif.user = resp.user
				notif.type = 'answer' 
				notification.postNotification notif, (err, respNotif) ->
					if err? 
						return done err
					else
						qdb.getQuestion resp.question, (err, res) ->
							if not err?
								utils.actOnSubscriptionResponse socket, 'questions', resp.question, ()->
									return done null, resp
							else
								return done err
								#mapping.getMapping res.user, (socket) ->
								#	if socket?
								#		socket.emit '/stream', resp
						#subscription.sendAnswer resp, socket
						#done null, resp
	,
	postRatings : (data, userId, done) ->
		if data.thumbs is 0
			qdb.removeVote data._id, userId, (err, resp) ->
				if err?
					return done err, null
				else
					return done null, resp
		else if data.thumbs is 1
			qdb.addToVotesUp data._id, userId, (err, resp) ->
				if err?
					return done err, null
				else
					return done null, resp
		else
			qdb.addToVotesDown data._id, userId, (err, resp) ->
				if err?
					return done err, null
				else
					return done null, resp
}
