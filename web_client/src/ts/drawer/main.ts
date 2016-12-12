import DrawerCanvas from './drawer';
module Drawer{
    let _stage:PIXI.Container;
    const canvas:DrawerCanvas = new DrawerCanvas();
    const background:PIXI.Graphics = new PIXI.Graphics();
    export function init(stage:PIXI.Container){
        _stage = stage;
        _stage.addChild(background);
        canvas.init();
        _stage.addChild(canvas);
    }
    export function update(){
    }
    export function resize(width:number, height:number):void{
        background.clear();
        background.beginFill(0xFFFFFF);
        background.drawRect(0, 0, width, height);
        canvas.resize(width, height);
    }
    export function getData():string{
        return canvas.getData();
    }
}
export{
    Drawer
}