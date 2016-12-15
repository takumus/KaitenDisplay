import DrawerCanvas from './drawer';
import Button from './button';
module Drawer{
    let _stage:PIXI.Container;
    const canvas:DrawerCanvas = new DrawerCanvas();
    const background:PIXI.Graphics = new PIXI.Graphics();
    const clearButton:Button = new Button("消す", 0x333333, 0xFFFFFF);
    const sendButton:Button = new Button("タイヤに送る！", 0xFF6666, 0xFFFFFF)
    export let onSend:(byButton:boolean)=>void = null;
    export function init(stage:PIXI.Container){
        _stage = stage;
        _stage.addChild(background);
        canvas.init();
        _stage.addChild(canvas);
        _stage.addChild(sendButton, clearButton);
        clearButton.on("tap", ()=>{
            //if(window.confirm("全て消しますか?")){
            canvas.reset();
            //}
        });
        sendButton.on("tap", ()=>{
            if(onSend) onSend(true);
        });
        canvas.onDraw = ()=>{
            if(onSend) onSend(false);
        }
    }
    export function update(){
    }
    export function resize(width:number, height:number):void{
        background.clear();
        background.beginFill(0xFFFFFF);
        background.drawRect(0, 0, width, height);
        canvas.resize(width, width);
        const bh = (height - width)/2;
        clearButton.resize(width, bh);
        sendButton.resize(width, bh);
        clearButton.y = width;
        sendButton.y = width + bh;
    }
    export function getData():string{
        return canvas.getData();
    }
}
export{
    Drawer
}