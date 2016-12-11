export default class DrawerCanvas{
    public canvas:PIXI.Sprite = new PIXI.Sprite();
    private graphics:PIXI.Graphics = new PIXI.Graphics();
    private mask:PIXI.Graphics = new PIXI.Graphics();
    private wheel:PIXI.Graphics = new PIXI.Graphics();
    private data:string;
    constructor(){
        this.canvas.addChild(this.graphics);
        this.canvas.addChild(this.mask);
        this.canvas.addChild(this.wheel);
        this.graphics.mask = this.mask;
    }
    public resize(width:number, height:number):void{
        this.mask.clear();
        this.mask.beginFill(0xFFFFFF);
        this.mask.drawCircle(width / 2, width / 2, width / 2);
        this.wheel.clear();
        this.wheel.lineStyle(10);
        this.wheel.drawCircle(width / 2, width / 2, width / 2);
        this.wheel.beginFill(0xFFFFFF);
        this.wheel.drawCircle(width / 2, width / 2, width *0.1);
    }
    public init():void{
        this.initMouseEvent();
        this.reset();
    }
    public reset():void{
        this.data = "";
        this.graphics.clear();
    }
    public getData():string{
        return this.data;
    }
    public initMouseEvent():void{
        //タッチ禁止
        let drawing:boolean = false;
        document.addEventListener("touchstart",(e:TouchEvent)=>{
            e.preventDefault();
            this.graphics.lineStyle(20, 0xff0000);
            const x = e.touches[0].clientX*2;
            const y = e.touches[0].clientY*2;
            this.graphics.moveTo(x, y);
            this.data += "b,";
            this.data += x+":"+y+",";
        });
        document.addEventListener("touchmove",(e:TouchEvent)=>{
            e.preventDefault();
            const x = e.touches[0].clientX*2;
            const y = e.touches[0].clientY*2;
            this.graphics.lineTo(x, y);
            this.data += x+":"+y+",";
        });
        document.addEventListener("touchend",(e:TouchEvent)=>{
            e.preventDefault();
        });
    }
}