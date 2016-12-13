export module Renderer{
	export let renderer:PIXI.CanvasRenderer;
	export let stage:PIXI.Container;
	export function init(_stage:PIXI.Container):void{
		renderer = new PIXI.CanvasRenderer();
		renderer.view.style.width = "100%";
		renderer.view.style.height = "100%";
		stage = _stage;
	}
	export function resize(width:number, height:number):void{
		renderer.resize(width, height);
	}
	export function update():void{
		renderer.render(stage);
	}
}