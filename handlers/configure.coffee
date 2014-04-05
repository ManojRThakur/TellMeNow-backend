user = require 'user'
qa = require 'qa'
utils = require 'utils'

configure = (io , done) ->
	io.sockets.on 'connection', (socket) ->
  		
  		socket.on '/user/token', (data) ->
    		#token stuff
    	socket.on '/suggest/place', (data) ->
    		#autocomplete place query
    	socket.on '/suggest/question', (data) ->
    		#autocomplete place query
    	socket.on '/question/post', (data) ->
			   # post question
         qa.postQuestion data, socket, (err,resp) ->
            if err  
              utils.sendError socket, err
            else
              utils.sendSuccess socket, resp
    	socket.on '/answer/post', (data) ->
    		# post answer
  		

	