const PORT = 3001;
const net = require('net');
const clients = {};
const server = net.createServer((conn)=>{
	console.log('server-> tcp server created');
	conn.on('data', (data)=>{
		console.log('server-> ' + data + ' from ' + conn.remoteAddress + ':' + conn.remotePort);
		conn.write('server -> Repeating: ' + data);
	});
	conn.on('close', ()=>{
		console.log('server-> client closed connection');
	});
	let s = "+";
	for(let i = 0; i < 20; i ++){
		s += "aaaaaaaaaa";
	}
	conn.write(s);
	conn.write("-\n");
}).listen(PORT);
console.log('listening on port ' + PORT);