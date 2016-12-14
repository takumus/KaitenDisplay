import {Drawer} from './drawer/main';
import {Renderer} from './renderer';
const stage:PIXI.Container = new PIXI.Container();
let width:number;
let height:number;
const init = ()=> {
	Renderer.init(stage);
	document.getElementById("content").appendChild(Renderer.renderer.view);
	window.addEventListener("resize", resize);
	Drawer.init(stage);
	resize();
	draw();
	const webSocket = new WebSocket("ws://takumus.com:3002");
	webSocket.onopen = ()=>{
		webSocket.send(JSON.stringify({
			key:location.hash.substr(1)
		}));
		console.log(location.hash.substr(1));
	}
	webSocket.onclose = ()=>{
		//alert("接続解除されました。\n遊んでいただきありがとうございます。");
	}
	Drawer.onSend = ()=>{
		const data = {
			data:{
				line:Drawer.getData(),
				width:width,
				height:height
			},
			key:location.hash.substr(1)
		}
		if(webSocket.readyState != 1){
			alert("外からは送信できません。\nもう一度遊ぶ場合は、\nまたお越しください。");
			return;
		}
		webSocket.send(JSON.stringify(data));
		alert("タイヤに送信しました");
	}
}
const draw = ()=> {
	TWEEN.update();
	requestAnimationFrame(draw);
}
const resize = ()=> {
	width = document.documentElement.clientWidth*2;
	height = document.documentElement.clientHeight*2;
	Renderer.resize(width, height);
	Drawer.resize(width, height);
	Renderer.update();
	Drawer.update();
}
window.onload = init;