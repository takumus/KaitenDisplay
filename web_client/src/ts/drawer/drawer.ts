export default class DrawerCanvas{
    public canvas:PIXI.Graphics = new PIXI.Graphics();
    private data:string;
    constructor(){

    }
    public resize(width:number, height:number):void{
        
    }
    public init():void{
        this.initMouseEvent();
        this.reset();
    }
    public reset():void{
        this.data = "";
        this.canvas.clear();
    }
    public getData():string{
        return this.data;
    }
    public initMouseEvent():void{
        //タッチ禁止
        let drawing:boolean = false;
        document.addEventListener("touchstart",(e:TouchEvent)=>{
            e.preventDefault();
            this.canvas.lineStyle(10, 0xff0000);
            const x = e.touches[0].clientX*2;
            const y = e.touches[0].clientY*2;
            this.canvas.moveTo(x, y);
            this.data += "b,";
            this.data += x+":"+y+",";
        });
        document.addEventListener("touchmove",(e:TouchEvent)=>{
            e.preventDefault();
            const x = e.touches[0].clientX*2;
            const y = e.touches[0].clientY*2;
            this.canvas.lineTo(x, y);
            this.data += x+":"+y+",";
        });
        document.addEventListener("touchend",(e:TouchEvent)=>{
            e.preventDefault();
        });
    }
}