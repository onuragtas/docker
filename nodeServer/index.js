var app = require('express')();
var http = require('http').Server(app);
var io = require('socket.io')(http);

app.get('/', function (req, res) {
    res.send('Node server is running');
});

io.on('connection', function (socket) {
    console.log('a user connected');

    socket.on('chat message', function (message) {
        console.log('message: ' + message);
    });

    socket.on('disconnect', function () {
        console.log('a user disconnected');
    });
});

http.listen(3000, function () {
    console.log('listening on 3000');
});