window.addEventListener('load',function() {
	document.body.innerText = "connecting";

	var host = "ws://raspberrypi.local:3000/";
	var socket = new WebSocket(host);
	socket.addEventListener('open', function() {
		document.body.innerText = "connected";
		var data = "";
		window.onclick = function(){
			socket.send(data + '\n');
		}
	});
});