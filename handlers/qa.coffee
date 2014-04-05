qdb = require '../models/qa'
subscription = require 'subscription'

postQuestion = (data, socket, done) ->
	qdb.postQuestion data, (err, resp) ->	
		if err
			done err, null
		else
			subscription.subscribe resp._id, socket, () ->
				done null, resp
			##publish to potential answrers

postAnswer = (data, socket, done) ->
	qdb.postAnswer data, (err, resp) ->	
		if err
			done err, null
		else
			subscription.sendAnswer resp, socket
			done null, resp