const spawn = require('child_process').spawn;
const app = spawn('./controller');
const net = require('net');

app.stdout.on('data', (data) => {
	console.log(data);
});
app.stderr.on('data', (data) => {

});
app.on('close', (code) => {

});

var ws = require('websocket.io');

const server = ws.listen(3000, ()=> {
	console.log('Server is running.');
});

server.on('connection', (socket) => {
	socket.on('message', (data) => {
		console.log(data.toString());
		app.stdin.write(new Buffer(data + '\n'));
	});
});