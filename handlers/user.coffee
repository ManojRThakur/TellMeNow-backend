qdb = require '../models/qa'

postQuestion = (data, done) ->
	qdb.postQuestion data, (err, resp) ->	
		if err
			done err, null
		else
			

postAnswer = (data) ->

