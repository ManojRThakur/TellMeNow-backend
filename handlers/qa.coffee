qdb = require '../models/qa'
locationsdb = require '../models/location'
subscription = require './subscription'
async = require 'async'

module.exports = {
	postQuestion  : (data, socket, done) ->

		qdb.postQuestion data, (err, resp) ->
			if err?
				done err, null
			else
				#subscribe , add in place table 
				async.series [
					(done) ->
						subscription.subscribe resp._id, socket, () ->
							console.log 'Entered 1'
							done null, resp
					,
					(done) ->
						question = {_id: data.place, questions : resp._id}
						locationsdb.addQuestions question, (err, dataResp) ->
							console.log 'Entered 2'
							if err? 
								done err
							else
								done dataResp
				],
				(err, results) ->
					if err? and err.length > 0
						return done err
					else
						return done results
				##publish to potential answrers
				## add question in place table 
	,
	postAnswer : (data, socket, done) ->
		qdb.postAnswer data, (err, resp) ->	
			if err
				done err, null
			else
				subscription.sendAnswer resp, socket
				done null, resp
}