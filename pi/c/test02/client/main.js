window.addEventListener('load',function() {
	var host = "ws://raspberrypi.local:3000/";
	var socket = new WebSocket(host);

	document.body.innerText = "connecting";
	socket.addEventListener('open', function() {
		document.body.innerText = "connected";
	});
	socket.addEventListener('message', function(message) {

	});
	socket.addEventListener('close', function() {

	});
	window.addEventListener('unload', function() {
		socket.onclose();
	});

	document.addEventListener('mousemove', function(e) {
		var y = e.clientY/window.innerHeight;
		send(y);
	});
	
	document.addEventListener('touchmove', function(e) {
		var y = e.touches[0].clientY/window.innerHeight;
		send(y);
		e.preventDefault();
	});

	var send = function(y) {
		var id = Math.floor(y * 16);
		var str = "";
		for(var i = 0; i < 16; i ++){
			str += i==id?'1':'0';
		}
		socket.send(str+'\n');
	}
});