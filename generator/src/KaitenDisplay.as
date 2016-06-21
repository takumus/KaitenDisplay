package
{
	import com.takumus.kaitenDisplay.Generator;
	
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	public class KaitenDisplay extends Sprite
	{
		public function KaitenDisplay()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			Canvas.init(this.stage);
			var g:Generator = new Generator();
			g.init(48, 48, 0);
			
			var loader:Loader = new Loader();
			loader.load(new URLRequest("file:///C:/Users/takumus/Desktop/testimage.png?"+new Date().getTime()));
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event):void{
				var bmd:BitmapData = new BitmapData(loader.width, loader.height, false, 0xffffff);
				bmd.draw(loader);
				var data:String = g.generate(bmd,600);
				trace(data);
				Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, "<\n"+data+">\n");
				stage.stageWidth = bmd.width;
				stage.stageHeight = bmd.height;
			});
		}
	}
}