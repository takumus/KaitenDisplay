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
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.net.dns.AAAARecord;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class UploadMasterProcess extends Sprite
	{
		private var _uploader:Uploader;
		private var _log:TextField;
		private var _kdf:KDFile;
		private var _sockets:SocketManager;
		private var _renderer:Renderer;
		private var _bitmap:Bitmap;
		public function UploadMasterProcess()
		{
			initSockets();
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			_uploader = new Uploader("raspberrypi.local", 3001);
			_uploader.addEventListener(UploaderEvent.CONNECT, connected);
			_renderer = new Renderer();
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
		private function initSockets():void
		{
			_sockets = new SocketManager(18760);
			//ソケットから受信
			_sockets.addEventListener(SocketManagerEvent.COMPLETE, function(e:SocketManagerEvent):void
			{
				log("received ("+e.client.id+") : "+e.bytesTotal+"byte");
				trace(e.data.length);
				var timeline:Timeline = _kdf.loadBinary(e.data);
				
				_renderer.render(
					timeline.frames[0], 
					stage.stageWidth, stage.stageHeight, 
					timeline.generatorOptions
				);
			});
			//ソケットから受信中
			_sockets.addEventListener(SocketManagerEvent.PROGRESS, function(e:SocketManagerEvent):void
			{
				log("receiving (" + e.client.id+") : " + e.bytesLoaded + "/" + e.bytesTotal + "byte");
			});
			_sockets.addEventListener(SocketManagerEvent.CONNECTED, function(e:SocketManagerEvent):void
			{
				log("child joined ("+e.client.id+")");
			});
			_sockets.addEventListener(SocketManagerEvent.DISCONNECTED, function(e:SocketManagerEvent):void
			{
				log("child disconnected ("+e.client.id+")");
			});
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
			this.graphics.clear();
			this.graphics.beginFill(0x000000);
			this.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
		}
		private function log(v:*):void
		{
			_log.text += v+"\n";
			_log.scrollV = _log.maxScrollV;
		}
	}
}