package
{
	import com.takumus.kaitenDisplay.Generator;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	public class KaitenDisplay extends Sprite
	{
		public function KaitenDisplay()
		{
			var g:Generator = new Generator();
			g.init(21,20, 10);
			g.generate(new BitmapData(60,60,false,0xffffff),360);
		}
	}
}