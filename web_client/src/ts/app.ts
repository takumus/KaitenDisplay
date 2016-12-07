import {Drawer} from './drawer/drawer';
const renderer = PIXI.autoDetectRenderer(800, 800);
const stage:PIXI.Container = new PIXI.Container();

const init = ()=> {
	renderer.view.style.width = "100%";
	renderer.view.style.height = "100%";
	document.getElementById("content").appendChild(renderer.view);
	window.addEventListener("resize", resize);
	Drawer.init(stage);
	resize();
	draw();
}
const draw = ()=> {
	TWEEN.update();
	renderer.render(stage);
	Drawer.update();
	requestAnimationFrame(draw);
}
const resize = ()=> {
	const width:number = window.innerWidth*2;
	const height:number = window.innerHeight*2;
	renderer.resize(width, height);
	Drawer.resize(width, height);
}
window.onload = init;