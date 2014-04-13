user = require './user'
qa = require './qa'
utils = require './utils'
location = require './locations'
mapping = require './mapping'
commentfollowup = require './commentsfollowups'

module.exports = {

	configure : (io , done) ->
		io.sockets.on 'connection', (socket) ->
			
			socket.on '/login', (data,callback) ->
				#token stuff
				#get user acces token , get the userId , and if userId is present then dont do anything else add the new user
				user.login socket, data, (err, resp) ->
					if not err?
						socket.userId = resp._id
						mapping.addMapping(resp._id, socket)
					callback
						error : err
						response: resp
			#add subscription here
			socket.on '/users/get', (ids, callback) ->
				user.find ids, (err, resp) ->
					utils.addSubscription socket, 'users', ids, () -> 
						callback
							error: err
							response: resp
			#add subscription here
			socket.on '/questions/get', (ids, callback) ->
				qa.getQuestions ids, (err, resp) ->
					utils.addSubscription socket, 'questions', ids, () -> 
						callback
							error : err
							response : resp
			socket.on '/answers/get', (ids, callback) ->
				qa.getAnswers ids, (err, resp) ->
					utils.addSubscription socket, 'answers', ids, () -> 
						callback
							error : err
							response : resp
			socket.on '/suggest/place', (data) ->
				#autocomplete place query
			socket.on '/suggest/question', (data) ->
				#autocomplete place query
			socket.on '/question/post', (data, callback) ->
				if not data.user?
					data.user = socket.userId
				qa.postQuestion data, socket, (err, resp) ->
					callback
						error : err
						response: resp
			socket.on '/location/find', (data, callback) ->
				location.getSuggestedLocations data, (err, resp) ->
					callback
						error: err
						response: resp.map (x) -> _id: x._id.toString("utf8"), name: x.name
			socket.on '/location/query', (data, callback) ->
				location.getSuggestedLocationsByKeyword data, (err, resp) ->
					callback
						error: err
						response: resp.map (x) -> _id: x._id.toString("utf8"), name: x.name
			#add subscription here
			socket.on '/location/get', (data, callback) ->
				location.getLocationById data.id, (err, resp) ->
					utils.addSubscription socket, 'locations', data._id, () ->
						callback
							error: err
							response: { "_id": resp._id.toString("utf-8"), name: resp.name}
			socket.on '/answer/post', (data, callback) ->
				if not data.user?
					data.user = socket.userId
				qa.postAnswer data, socket, (err, resp) ->
					callback
						error : err
						response: resp
			socket.on '/comments/get', (data, callback) ->
				commentfollowup.getComments data, (err, resp) ->
					callback
						error : err
						response: resp
			socket.on '/followups/get', (data, callback) ->
				commentfollowup.getFollowUps data, (err, resp) ->
					callback
						error : err
						response: resp
			socket.on '/comments/post', (data, callback) ->
				commentfollowup.postComments socket, data, (err, resp) ->
					callback
						error : err
						response: resp
			socket.on '/followups/post', (data, callback) ->
				commentfollowup.postFollowUps socket, data, (err, resp) ->
					callback
						error : err
						response: resp
}
		

	