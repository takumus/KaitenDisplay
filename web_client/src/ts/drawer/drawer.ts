module DrawerCanvas{
    export const canvas:PIXI.Graphics = new PIXI.Graphics();
    export function resize(width:number, height:number):void{
        
    }
    export function init():void{
        initMouseEvent();
    }
    function initMouseEvent():void{
        console.log(1)
        //タッチ禁止
        document.addEventListener("touchstart",(e)=>e.preventDefault());
        let drawing:boolean = false;
        canvas.lineStyle(10);
        document.addEventListener("mousedown", (e)=>{
            drawing = true;
            canvas.moveTo(e.clientX*2, e.clientY*2);
        });
        document.addEventListener("mousemove", (e)=>{
            if(!drawing) return;
            canvas.lineTo(e.clientX*2, e.clientY*2);
        });
        document.addEventListener("mouseup", (e)=>{
            drawing = false;
        });
    }
}
export{
    DrawerCanvas
}