const spawn = require('child_process').spawn;
const app = spawn('./controller');
const net = require('net');
const LED_LENGTH = 48;
app.stdout.on('data', (data) => {
	console.log(data);
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
const datas = {};
const fill = (()=> {
	var str = "";
	for(var i = 0; i < LED_LENGTH; i ++){
		str += '0';
	}
	return str;
})();
const write = () => {
	var cdata = fill.split("");
	for(const key in datas){
		const data = datas[key];
		data.forEach((d, i) => {
			if(d == '1'){
				cdata[i] = '1';
			}
		});
	}
	app.stdin.write(new Buffer(cdata.join("") + '\n'));
}

server.on('connection', (socket) => {
	const key = socket.req.headers['sec-websocket-key'];
	sockets[key] = socket;
	datas[key] = [];
	console.log('connected ' + key);
	socket.on('message', (data) => {
		datas[key] = data.split("");
		write();
	});
	socket.on('close', () => {
		console.log('closed');
		delete sockets[key];
		delete datas[key];
		write();
	});
	socket.on('disconnect', () => {
		console.log('disconnected');
		delete sockets[key];
		delete datas[key];
	});
});