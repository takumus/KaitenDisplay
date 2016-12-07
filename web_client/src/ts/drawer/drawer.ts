module Drawer{
    let _stage:PIXI.Container;
    const background:PIXI.Graphics = new PIXI.Graphics();
    export function init(stage:PIXI.Container){
        _stage = stage;
        _stage.addChild(background);
    }
    export function update(){
    }
    export function resize(width:number, height:number):void{
        background.clear();
        background.beginFill(0xFFFFFF);
        background.drawRect(0, 0, width, height);
    }
}
export{
    Drawer
}