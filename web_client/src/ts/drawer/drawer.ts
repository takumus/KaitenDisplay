export default class DrawerCanvas{
    public canvas:PIXI.Graphics = new PIXI.Graphics();
    constructor(){

    }
    public resize(width:number, height:number):void{
        
    }
    public init():void{
        this.initMouseEvent();
    }
    public initMouseEvent():void{
        //タッチ禁止
        let drawing:boolean = false;
        this.canvas.lineStyle(10, 0xff0000);
        document.addEventListener("touchstart",(e:TouchEvent)=>{
            e.preventDefault();
            this.canvas.moveTo(e.touches[0].clientX*2, e.touches[0].clientY*2);
            console.log(1);
        });
        document.addEventListener("touchmove",(e:TouchEvent)=>{
            e.preventDefault();
            this.canvas.lineTo(e.touches[0].clientX*2, e.touches[0].clientY*2);
            console.log(2);
        });
        document.addEventListener("touchend",(e:TouchEvent)=>{
            e.preventDefault();
        });
    }
}