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

			socket.on '/answer/post', (data, callback) ->
				if not data.user?
					data.user = socket.userId
				# post answer
				qa.postAnswer data, socket, (err, resp) ->
					callback
						error : err
						response: resp
}
		

	