window.addEventListener('load',function() {
	document.body.innerText = "connecting";

	var host = "ws://raspberrypi.local:3000/";
	var socket = new WebSocket(host);
	var defData = '0000000000000000';
	socket.addEventListener('open', function() {
		var strs = ['\\','-','/','|'];
		var n = 0;
		setInterval(function(){document.body.innerText = " connected " + strs[n++%3]}, 100);
	});
	socket.addEventListener('message', function(message) {

	});
	socket.addEventListener('close', function() {

	});
	window.addEventListener('unload', function() {
		socket.onclose();
	});

	var touch = function(e) {
		e.preventDefault();
		var data = defData.split("");
		for(var i in e.touches){
			data[Math.floor(e.touches[i].clientY/window.innerHeight*16)] = '1';
		}
		send(data.join(""));
	}
	var end = function(e){
		send(defData);
	}
	var send = function(data) {
		socket.send(data+'\n');
	}
	document.addEventListener('touchstart', touch);
	document.addEventListener('touchmove', touch);
	document.addEventListener('touchend', touch);
	document.addEventListener('touchcancel', end);
});