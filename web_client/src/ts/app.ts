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
		//webSocket.send("hello");
	}
	document.addEventListener("touchstart", (e:TouchEvent)=>{
		if(e.touches[0].clientY < 100){
			const data = {
				data:{
					line:Drawer.getData(),
					width:width,
					height:height
				},
				key:""
			}
			webSocket.send(JSON.stringify(data));
		}
	});
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