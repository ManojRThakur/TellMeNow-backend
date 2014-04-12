qdb = require '../models/qa'
locationsdb = require '../models/location'
subscription = require './subscription'
async = require 'async'
mapping = require './mapping'

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
						locationsdb.getLocation resp.place, (err,res) ->
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
							console.log 'Entered 2'
							if err? 
								done err
							else
								done null, dataResp
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
		qdb.getQuestionForUser id, (err, resp) ->
			if err
				return done err
			else
				return done null, resp
	,
	postAnswer : (data, socket, done) ->
		qdb.postAnswer data, (err, resp) ->	
			if err
				done err, null
			else
				qdb.getQuestion resp.question, (err, res) ->
					if not err?
						mapping.getMapping res.user, (socket) ->
							if socket?
								socket.emit '/stream', resp
				#subscription.sendAnswer resp, socket
				#done null, resp
}