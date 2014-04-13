comments = require '../models/comments'
followups = require '../models/followup'
notification = require '../models/notification'
utils = require './utils'

module.exports = 
	getComments : (ids, done) ->
		comments.getCommentInArray ids, (err, resp) ->
			if err?
				return done err
			else
				return done null, resp

	getFollowUps : (ids, done) ->
		followups.getFollowUpInArray ids, (err, resp) ->
			if err?
				return done err
			else
				return done null, resp
	
	postComments : (socket, data, done) ->
		comments.postComment data, (err, resp) ->
			if err?
				return done err
			else
				notif = {}
				notif.id = resp._id
				notif.user = resp.user
				notif.type = 'comment' 
				notification.postNotification notif, (err, respNotif) ->
					if err?
						return done err
					else
						utils.actOnSubscriptionResponse socket, 'questions', resp.question, ()-> 
							return done null, resp

	postFollowUps : (socket, data, done) ->
		followups.postFollowUp data, (err, resp) ->
			if err?
				return done err
			else
				notif = {}
				notif.id = resp._id
				notif.user = resp.user
				notif.type = 'followup' 
				notification.postNotification notif, (err, respNotif) ->
					if err?
						return done err
					else
						utils.actOnSubscriptionResponse socket, 'answer', resp.answer, ()-> 
						return done null, resp
