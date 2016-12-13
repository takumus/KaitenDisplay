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
        const cx = width / 2;
        const cy = width / 2;
        const cr = width*0.05;
        this.__mask.drawCircle(cx, cy, width / 2);
        this._wheel.clear();
        this._wheel.lineStyle(40, 0x000000);
        this._wheel.drawCircle(cx, cy, width / 2 - 20);
        this._wheel.lineStyle(40, 0x333333);
        this._wheel.drawCircle(cx, cy, width / 2 - 30);
        this._wheel.lineStyle(30, 0x999999);
        this._wheel.drawCircle(cx, cy, width / 2 - 40);
        this._wheel.lineStyle(10, 0x999999);
        this._wheel.beginFill(0xFFFFFF);
        this._wheel.drawCircle(cx, cy, cr);
        
        this.drawWheel(width / 2 - 40,cr,cx,cy,15);

    }
    private drawWheel(len:number, cr:number, cx:number, cy:number, count:number):void{
        const wireLength = count;
        const twist = 0.8;
        this._wheel.endFill();
        for(let i = 0; i < wireLength; i ++){
            const radian = i / wireLength * (Math.PI*2);
            const bx = Math.cos(radian-twist) * cr + cx;
            const by = Math.sin(radian-twist) * cr + cy;
            const ex = Math.cos(radian) * len + cx;
            const ey = Math.sin(radian) * len + cy;

            this._wheel.lineStyle();
            this._wheel.beginFill(0x666666);
            this._wheel.drawCircle(bx, by, 5);
            this._wheel.drawCircle(ex, ey, 5);
            this._wheel.endFill();

            this._wheel.lineStyle(4, 0xCCCCCC);
            this._wheel.moveTo(bx, by);
            this._wheel.lineTo(ex, ey);
        }
        const diff = (Math.PI*2) * (1/wireLength) / 2;
        for(let i = 0; i < wireLength; i ++){
            const radian = i / wireLength * (Math.PI*2);
            const bx = Math.cos(radian + twist + diff) * cr + cx;
            const by = Math.sin(radian + twist + diff) * cr + cy;
            const ex = Math.cos(radian + diff) * len + cx;
            const ey = Math.sin(radian + diff) * len + cy;

            this._wheel.lineStyle();
            this._wheel.beginFill(0x666666);
            this._wheel.drawCircle(bx, by, 5);
            this._wheel.drawCircle(ex, ey, 5);
            this._wheel.endFill();

            this._wheel.lineStyle(4, 0xCCCCCC);
            this._wheel.moveTo(bx, by);
            this._wheel.lineTo(ex, ey);
        }
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