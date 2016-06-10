package
{
	import com.takumus.kaitenDisplay.Generator;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	public class KaitenDisplay extends Sprite
	{
		public function KaitenDisplay()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			Canvas.init(this.stage);
			
			var g:Generator = new Generator();
			g.init(60,40,10);
			var data:String = g.generate(new BitmapData(500,500,false,0x000000),360);
			trace(data);
		}
	}
}