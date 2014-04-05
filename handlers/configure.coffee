user = require './user'
qa = require './qa'
utils = require './utils'
location = require './locations'

module.exports = {

	configure : (io , done) ->
		io.sockets.on 'connection', (socket) ->
			
			socket.on '/user/login', (data,callback) ->
				user.login data, socket, (err, resp) ->
					callback
						error : err
						response: resp
		  
			socket.on '/suggest/place', (data) ->
				#autocomplete place query
			socket.on '/suggest/question', (data) ->
				#autocomplete place query
			socket.on '/question/post', (data, callback) ->
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
				# post answer
				qa.postAnswer data, socket, (err, resp) ->
					callback
						error : err
						response: resp
}
		

	