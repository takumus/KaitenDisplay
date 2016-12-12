export default class DrawerCanvas extends PIXI.Container{
    private _graphics:PIXI.Graphics = new PIXI.Graphics();
    private __mask:PIXI.Graphics = new PIXI.Graphics();
    private _wheel:PIXI.Graphics = new PIXI.Graphics();
    private _data:string;
    constructor(){
        super();
        this.addChild(this._graphics);
        this.addChild(this.__mask);
        this.addChild(this._wheel);
        this._graphics.mask = this.__mask;
    }
    public resize(width:number, height:number):void{
        this.__mask.clear();
        this.__mask.beginFill(0xFFFFFF);
        this.__mask.drawCircle(width / 2, width / 2, width / 2);
        this._wheel.clear();
        this._wheel.lineStyle(10);
        this._wheel.drawCircle(width / 2, width / 2, width / 2);
        this._wheel.beginFill(0xFFFFFF);
        this._wheel.drawCircle(width / 2, width / 2, width *0.1);
    }
    public init():void{
        this.initMouseEvent();
        this.reset();
    }
    public reset():void{
        this._data = "";
        this._graphics.clear();
    }
    public getData():string{
        return this._data;
    }
    public initMouseEvent():void{
        //タッチ禁止
        let drawing:boolean = false;
        document.addEventListener("touchstart",(e:TouchEvent)=>{
            e.preventDefault();
            this._graphics.lineStyle(20, 0xff0000);
            const x = e.touches[0].clientX*2;
            const y = e.touches[0].clientY*2;
            this._graphics.moveTo(x, y);
            this._data += "b,";
            this._data += x+":"+y+",";
        });
        document.addEventListener("touchmove",(e:TouchEvent)=>{
            e.preventDefault();
            const x = e.touches[0].clientX*2;
            const y = e.touches[0].clientY*2;
            this._graphics.lineTo(x, y);
            this._data += x+":"+y+",";
        });
        document.addEventListener("touchend",(e:TouchEvent)=>{
            e.preventDefault();
        });
    }
}