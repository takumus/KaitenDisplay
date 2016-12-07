const spawn = require('child_process').spawn;
const app = spawn('./controller');
const net = require('net');

const WEBSOCKET_PORT = 3000;
const SOCKET_PORT = 3001;

app.stdout.on('data', (data) => {
	//console.log(data.toString().split("\n").join(""));
	process.stdout.write(data.toString());
});
app.on('close', (code) => {

});
//ウェブソケット
const ws = require('websocket.io');
const webSockets = {};
const webSocketServer = ws.listen(WEBSOCKET_PORT, ()=>{
	console.log('running websocket');
}).on('connection', (socket) => {
	const key = socket.req.headers['sec-websocket-key'];
	webSockets[key] = socket;
	console.log('ws:connected ' + key);
	socket.on('message', (data) => {
		app.stdin.write(new Buffer(data));
	});
	socket.on('close', () => {
		console.log('ws:closed');
		delete webSockets[key];
	});
	socket.on('disconnect', () => {
		console.log('ws:disconnected');
		delete webSockets[key];
	});
	socket.on('error', (error) => {
		console.log("ws:error");
		console.log(error.stack);
	});
});
//普通のソケット
const sockets = {};
const socketServer = net.createServer((socket) => {
	console.log('s:connected');
	socket.on('data', (data) => {
		app.stdin.write(new Buffer(data));
	});
	socket.on('close', () => {
		console.log('s:disconnected');
	});
	socket.on('error', (error) => {
		console.log("s:error");
		console.log(error.stack);
	});
}).listen(SOCKET_PORT);