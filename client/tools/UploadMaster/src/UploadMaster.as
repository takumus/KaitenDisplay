package
{
	import com.takumus.kaitenDisplay.KDFile;
	import com.takumus.kaitenDisplay.Renderer;
	import com.takumus.kaitenDisplay.RendererEvent;
	import com.takumus.kaitenDisplay.Timeline;
	import com.takumus.kaitenDisplay.Uploader;
	import com.takumus.kaitenDisplay.UploaderEvent;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.dns.AAAARecord;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class UploadMaster extends Sprite
	{
		private var _uploader:Uploader;
		private var _log:TextField;
		private var _kdf:KDFile;
		private var _sockets:SocketManager;
		private var _renderer:Renderer;
		private var _bitmap:Bitmap;
		public function UploadMaster()
		{
			_uploader = new Uploader("raspberrypi.local", 3001);
			_uploader.addEventListener(UploaderEvent.CONNECT, connected);
			_sockets = new SocketManager();
			_renderer = new Renderer();
			_sockets.addEventListener(SocketManagerEvent.COMPLETE, receivedFromClient);
			_sockets.addEventListener(SocketManagerEvent.PROGRESS, receivingFromClient);
			_renderer.addEventListener(RendererEvent.COMPLETE, completeRendering);
			_bitmap = new Bitmap();
			_kdf = new KDFile();
			
			_log = new TextField();
			_log.defaultTextFormat = new TextFormat("Consolas", 18, 0xffffff);
			this.addChild(_bitmap);
			this.addChild(_log);
			this.stage.addEventListener(Event.RESIZE, resize);
			resize(null);
			log("init");
		}
		private function receivedFromClient(event:SocketManagerEvent):void
		{
			log("received("+event.client.id+")");
			trace(event.data.length);
			var timeline:Timeline = _kdf.loadBinary(event.data);
			
			_renderer.render(
				timeline.frames[0], 
				stage.stageWidth, stage.stageHeight, 
				timeline.generatorOptions
			);
		}
		private function receivingFromClient(event:SocketManagerEvent):void
		{
			log("receiving("+event.client.id+"):" + event.bytesLoaded + "/" + event.bytesTotal);
		}
		private function connected(e:UploaderEvent):void
		{
			log("connected");
		}
		private function completeRendering(event:RendererEvent):void
		{
			_bitmap.bitmapData = event.data;
		}
		private function resize(e:Event):void
		{
			_log.width = stage.stageWidth;
			_log.height = stage.stageHeight;
		}
		private function log(v:*):void
		{
			_log.text += v+"\n";
			_log.scrollV = _log.maxScrollV;
		}
	}
}