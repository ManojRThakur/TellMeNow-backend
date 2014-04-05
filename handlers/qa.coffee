qdb = require '../models/qa'
locationsdb = require '../models/locations'
subscription = require './subscription'
async = require 'async'

postQuestion = (data, socket, done) ->
	qdb.postQuestion data, (err, resp) ->	
		if err
			done err, null
		else
			#subscribe , add in place table 
			async.series [
				subscribe: (done) ->
					subscription.subscribe resp._id, socket, () ->
						done null, resp
				,
				addQuestiontoPlace: (done) ->
					locationsdb.addQuestion data.place_id, resp._id, (err, dataResp) ->
						if err? 
							done err
						else
							done dataResp
			],
			(err, results) ->
				if err? and err.length > 0
					return done err
				else
					done results
			##publish to potential answrers
			## add question in place table 

postAnswer = (data, socket, done) ->
	qdb.postAnswer data, (err, resp) ->	
		if err
			done err, null
		else
			subscription.sendAnswer resp, socket
			done null, resp