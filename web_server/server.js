"use strict"
const SOCKET_PORT = 3001;
const HTTP_PORT = 3002;

const net = require('net');
const http = require('http');
const querystring = require('querystring');
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

const http_server = http.createServer((req, res)=> {
	if (req.url == "/" && req.method == "POST") {
        var tmpData = "";
        req.on('readable', (chunk) => {
			const d = req.read();
			if(d == null) return;
			tmpData += d;
        });
        req.on('end', () => {
			try{
				const data = JSON.parse(querystring.parse(tmpData).data);
				const lineData = data.data;
				console.log("received from client.");
				primarySocket.write(lineData + "\n");
				console.log("send to local server");
				res.end(tmpData);
			}catch(e){
				console.log(e.message);
			}
        });
    }
}).listen(HTTP_PORT);