package
{
	import com.takumus.kaitenDisplay.Generator;
	
	import flash.display.Sprite;
	
	public class KaitenDisplay extends Sprite
	{
		public function KaitenDisplay()
		{
			var g:Generator = new Generator();
			g.init(9,1);
		}
	}
}