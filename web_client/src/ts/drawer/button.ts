export default class Button extends PIXI.Container{
    private background:PIXI.Graphics;
    private label:PIXI.Text;
    private bgColor:number;
    private labelColor:number;
    constructor(label:string, bgColor:number, labelColor:number){
        super();
        this.interactive = true;
        this.bgColor = bgColor;
        this.labelColor = labelColor;

        this.background = new PIXI.Graphics();
        const labelStyle:PIXI.TextStyle = new PIXI.TextStyle();
        labelStyle.fontSize = 50;
        labelStyle.fill = this.labelColor;
        this.label = new PIXI.Text(label, labelStyle);
        this.label.anchor.set(0.5, 0.5);
        this.addChild(this.background);
        this.addChild(this.label);
    }
    public resize(width:number, height:number):void{
        this.background.clear();
        this.background.beginFill(this.bgColor);
        this.background.drawRect(0, 0, width, height);
        this.label.x = width / 2;
        this.label.y = height / 2;
    }
}