comments = require '../models/comments'
followups = require '../models/followup'

module.exports = 
	getComments : (data, done) ->
		comments.getCommentByQuestionId data.question, (err, resp) ->
			if err?
				return done err
			else
				return done null, resp

	getFollowUps : (data, done) ->
		followups.getFollowUpByAnswerId data.answer, (err, resp) ->
			if err?
				return done err
			else
				return done null, resp
	
	postComments : (data, done) ->
		comments.postComment data, (err, resp) ->
			if err?
				return done err
			else
				return done null, resp

	postFollowUps : (data, done) ->
		followups.postFollowUp data, (err, resp) ->
			if err?
				return done err
			else
				return done null, resp