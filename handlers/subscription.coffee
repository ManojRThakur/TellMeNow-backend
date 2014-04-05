subscribe = (qid, socket, done) ->
	socket.join qid
	do done

sendAnswer = (answer, socket) ->
	socket.in(answer.questionId).emit answer