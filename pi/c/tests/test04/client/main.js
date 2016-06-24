window.addEventListener('load',function() {
	document.body.innerText = "connecting";

	var host = "ws://raspberrypi.local:3000/";
	var socket = new WebSocket(host);
	var defData = '0000000000000000';
	socket.addEventListener('open', function() {
		document.body.innerText = "connected";
		var data = "";
		for(var r = 0; r < 3600; r ++){
			for(var l = 0; l < 64; l ++){
				data += l%2==0?'1':'0';
			}
			data += '\n';
		}
		window.onclick = function(){
			socket.send(data + 'i\n');
		}
	});
});