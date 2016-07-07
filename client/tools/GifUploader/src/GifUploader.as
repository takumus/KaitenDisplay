package
{
	import com.takumus.kaitenDisplay.GeneratorEvent;
	import com.takumus.kaitenDisplay.GeneratorOptions;
	import com.takumus.kaitenDisplay.KDFile;
	import com.takumus.kaitenDisplay.SerialGenerator;
	import com.takumus.kaitenDisplay.SerialGeneratorEvent;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	
	import org.bytearray.gif.events.GIFPlayerEvent;
	import org.bytearray.gif.frames.GIFFrame;
	import org.bytearray.gif.player.GIFPlayer;
	
	public class GifUploader extends Sprite
	{
		private const TYPES:Array = [new FileFilter("gifアニメだけだよ", "*.gif")];
		private var _gifPlayer:GIFPlayer;
		private var _file:File;
		private var _generator:SerialGenerator;
		public function GifUploader()
		{
			_gifPlayer = new GIFPlayer();
			_file = new File();
			_file.addEventListener(Event.SELECT, select);
			_generator = new SerialGenerator();
			
			_gifPlayer.addEventListener(GIFPlayerEvent.COMPLETE, loaded);
			this.stage.addEventListener(MouseEvent.CLICK, open);
			_generator.addEventListener(SerialGeneratorEvent.COMPLETE, generated);
			
			this.addChild(_gifPlayer);
		}
		private function loaded(event:Event):void
		{
			_generator.clear();
			var length:int = _gifPlayer.totalFrames;
			for(var i:int = 0; i < length; i ++){
				var frame:GIFFrame = _gifPlayer.frames[i];
				for(var f:int = 0; f < frame.delay/10; f ++){
					_generator.add(frame.bitmapData);
				}
			}
			_generator.setOptions(new GeneratorOptions(48, 48, 10, 360, false, 150));
			_generator.generate();
		}
		private function generated(event:SerialGeneratorEvent):void
		{
			var kdf:KDFile = new KDFile();
			kdf.save(File.desktopDirectory.resolvePath("aaa.kd"), event.data);
		}
		private function select(event:Event):void
		{
			_gifPlayer.load(new URLRequest(_file.url));
		}
		private function open(event:MouseEvent):void
		{
			_file.browse(TYPES);
		}
	}
}