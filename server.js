var http = require('http');
var path = require('path');
var async = require('async');
var socketio = require('socket.io');
var express = require('express');
var router = express();
var server = http.createServer(router);
var io = socketio.listen(server);
router.use(express.static(path.resolve(__dirname, 'client')));

var numUsers = [];
var id = [];
var cods = new Array(3);
var aa = 3;

var stanowisko = [

  {
    name: "Stanowisko 1",
    id: 0
  }, {
    name: "Stanowisko 2",
    id: 1
  }, {
    name: "Stanowisko 3",
    id: 2
  }
];

for (var i = 0; i < 3; i++) {
  cods[i] = new Array(1);
  numUsers[i] = 0;
  id[i] = 1;
}

io.on('connection', function(socket) {
  console.log('A user connected');
  socket.emit('connectionShop', {
    numUsers: numUsers,
    id: id,
    stanowisko: stanowisko,
    nb: aa
  });

  socket.on('addQ', function(data) {
    stanowisko.push({
      name: data,
      id: aa
    });
    cods[aa] = new Array(1);
    numUsers[aa] = 0;
    id[aa] = 1;
    aa++;

  });

  socket.on('nextClient', function(data) {
    if (id[data] - numUsers[data] > 1) {
      ++numUsers[data];
      emitNum();
    }
  });

  socket.on('setIn', function(data) {
    cods[data][id[data]] = Math.floor(Math.random() * 8888) + 1111;
    ++id[data];
    emitNum();
  });

  function emitNum() {
    socket.emit('changeNum', {
      numUsers: numUsers,
      id: id,
      code: cods
    });
    socket.broadcast.emit('changeNumBroad', {
      numUsers: numUsers,
      id: id,
      code: cods,
      nb: aa
    });
  }

  //Whenever someone disconnects this piece of code executed
  socket.on('disconnect', function() {
    console.log('A user disconnected');
  });
});
server.listen(process.env.PORT || 3000, process.env.IP || "0.0.0.0", function() {
  var addr = server.address();
  console.log("Server listening at", addr.address + ":" + addr.port);
});
