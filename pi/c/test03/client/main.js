window.addEventListener('load',function() {
	document.body.innerText = "connecting";

	var host = "ws://raspberrypi.local:3000/";
	var socket = new WebSocket(host);
	var defData = '0000000000000000';
	socket.addEventListener('open', function() {
		socket.send(data+'\n');
	});
});