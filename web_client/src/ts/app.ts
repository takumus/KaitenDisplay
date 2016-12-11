import {Drawer} from './drawer/main';
let renderer:PIXI.CanvasRenderer;
const stage:PIXI.Container = new PIXI.Container();
let width:number;
let height:number;
const init = ()=> {
	renderer = new PIXI.CanvasRenderer(800, 800);
	renderer.view.style.width = "100%";
	renderer.view.style.height = "100%";
	document.getElementById("content").appendChild(renderer.view);
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
	renderer.render(stage);
	Drawer.update();
	requestAnimationFrame(draw);
}
const resize = ()=> {
	width = document.documentElement.clientWidth*2;
	height = document.documentElement.clientHeight*2;
	renderer.resize(width, height);
	Drawer.resize(width, height);
}
window.onload = init;