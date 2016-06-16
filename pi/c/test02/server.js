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

const server = net.createServer((conn) => {
	console.log('connected');
	conn.on('data', (data) => {
		console.log(data.toString());
		app.stdin.write(new Buffer(data + '\n'));
	});
	conn.on('close', () => {
		console.log('disconnected');
	});
}).listen(3000);