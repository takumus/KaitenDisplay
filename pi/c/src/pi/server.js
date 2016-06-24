const spawn = require('child_process').spawn;
const app = spawn('./controller');
const net = require('net');

app.stdout.on('data', (data) => {
	console.log(data.toString());
});
app.stderr.on('data', (data) => {

});
app.on('close', (code) => {

});

const ws = require('websocket.io');
const server = ws.listen(3000, ()=> {
	console.log('Server is running.');
});

const sockets = {};
server.on('connection', (socket) => {
	const key = socket.req.headers['sec-websocket-key'];
	sockets[key] = socket;
	console.log('connected ' + key);
	socket.on('message', (data) => {
		//console.log(data);
		app.stdin.write(new Buffer(data));
	});
	socket.on('close', () => {
		console.log('closed');
		delete sockets[key];
	});
	socket.on('disconnect', () => {
		console.log('disconnected');
		delete sockets[key];
	});
});