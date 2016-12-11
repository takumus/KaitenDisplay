import {Drawer} from './drawer/main';
let renderer:PIXI.CanvasRenderer;
const stage:PIXI.Container = new PIXI.Container();
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
		webSocket.send("hello");
	}

}
const draw = ()=> {
	TWEEN.update();
	renderer.render(stage);
	Drawer.update();
	requestAnimationFrame(draw);
}
const resize = ()=> {
	const width:number = document.documentElement.clientWidth*2;
	const height:number = document.documentElement.clientHeight*2;
	renderer.resize(width, height);
	Drawer.resize(width, height);
}
window.onload = init;