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
	
	Drawer.onSend = ()=>{
		let key = location.href.split("?")[1];
		key = key?key:"none";
		const data = {
			data:JSON.stringify({
				line:Drawer.getData(),
				width:width,
				height:height
			}),
			key:key
		}
		//if(webSocket.readyState != 1){
		//	alert("外からは送信できません。\nもう一度遊ぶ場合は、\nまたお越しください。");
		//	return;
		//}
		//webSocket.send(JSON.stringify(data));
		post("http://takumus.com/kd/", JSON.stringify(data), "post");
		//alert("タイヤに送信しました");
	}
}
const post = (path, data, method) => {
    var req = new XMLHttpRequest();
	req.open(method, path, false);
	req.setRequestHeader('content-type',
	'application/x-www-form-urlencoded;charset=UTF-8');
	req.send('data=' + encodeURIComponent(data));
	if(req.status == 200){
		alert("タイヤへ送信完了！");
	}else{
		alert("残念だ！\nもう送信できない！\n最新のQRコードが必要なんですよ。\nもう一回来てください。");
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