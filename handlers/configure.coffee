user = require './user'
qa = require './qa'
utils = require './utils'
location = require './locations'
mapping = require './mapping'

module.exports = {

	configure : (io , done) ->
		io.sockets.on 'connection', (socket) ->
			
			socket.on '/user/login', (data,callback) ->
				#token stuff
				#get user acces token , get the userId , and if userId is present then dont do anything else add the new user
				user.login data, (err, resp) ->
					if not err?
						socket.userId = resp._id
						mapping.addMapping(resp._id, socket)
					callback
						error : err
						response: resp
			#add subscription here
			socket.on '/user/find', (data, callback) ->
				user.find data.id, (err, resp) ->
					response = {}
					response._id = resp._id;
					response.name = resp.name;
					response.reputation = resp.reputation;
					response.notificationsSet = resp.notificationsSet;
					utils.addSubscription socket, 'users', data.id, () ->
						callback
							error: err
							response: response
			#add subscription here
			socket.on '/questions/get', (data, callback) ->
				qa.getQuestions data.id, (err, data) ->
					utils.addSubscription socket, 'questions', data.id, () ->
						callback
							error : err
							response : data
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
					utils.addSubscription socket, 'locations', data.id, () ->
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
}
		

	