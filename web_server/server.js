"use strict"
const SOCKET_PORT = 3001;
const WS_PORT = 3002;

const net = require('net');
var ws = require("nodejs-websocket")

let primarySocket;

let key = "";

const server = net.createServer((socket)=>{
	console.log('uploader connected');
	socket.on('data', (dataStr)=>{
		try{
			const data = JSON.parse(dataStr);
			key = data.key;
			console.log("key updated : " + key);
			ws_server.connections.forEach((c)=>{
				c.close();
			})
		}catch(e){

		}
	});
	socket.on('close', ()=>{
		console.log('closed socket');
	});
	primarySocket = socket;
}).listen(SOCKET_PORT);

const ws_server = ws.createServer(function (conn) {
    console.log("client connected")
	console.log(ws_server.connections.length);
    conn.on("text", function (str) {
		try{
			const data = JSON.parse(str);
			if(data.key != key){
				conn.close();
				console.log("get data from old user");
				return;
			}
			console.log("send to local server");
			primarySocket.write(JSON.stringify(data.data)+"\n");
			//console.log(primarySocket);
		}catch(e){
			console.log(e.message);
		}
    })
    conn.on("close", function (code, reason) {
        console.log("client disconnected")
    })
}).listen(WS_PORT);

console.log('socket listening on port ' + SOCKET_PORT);
console.log('websocket listening on port ' + WS_PORT);