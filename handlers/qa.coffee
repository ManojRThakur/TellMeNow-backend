qdb = require '../models/qa'
locationsdb = require '../models/location'
notification = require '../models/notification'
subscription = require './subscription'
async = require 'async'
mapping = require './mapping'
utils = require './utils'

module.exports = {
	postQuestion  : (data, socket, done) ->

		qdb.postQuestion data, (err, resp) ->
			if err?
				done err, null
			else
				#subscribe , add in place table 
				async.series [
					(done) ->
						console.log resp
						locationsdb.getLocationById resp.place, (err,res) ->
							if not err?
								for user in res.users
									mapping.getMapping user, (socket) ->
										if socket?
											socket.emit '/stream', resp
								done err, resp 
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
						return done null, results
				##publish to potential answrers
				## add question in place table 
	,
	getQuestions: (id, done) ->
		qdb.getQuestion id, (err, resp) ->
			resp = resp.toJSON()
			if err
				return done err
			else
				qdb.getAnswersByQuestionId id, (err, qresp) ->
					if err
						return done err
					else			
						answers = []
						for answer in qresp
							answers.push answer._id
						resp.answers = answers
						console.log resp
						return done null, resp
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
								utils.actOnSubscriptionResponse socket, 'question', resp.question, ()->
									return done null, resp
							else
								return done err
								#mapping.getMapping res.user, (socket) ->
								#	if socket?
								#		socket.emit '/stream', resp
						#subscription.sendAnswer resp, socket
						#done null, resp
	}