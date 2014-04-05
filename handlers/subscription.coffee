subscribe = (qid, socket, done) ->
	socket.join qid
	do done

publish = (data, socket) ->
	socket.in(data.questionId).emit data