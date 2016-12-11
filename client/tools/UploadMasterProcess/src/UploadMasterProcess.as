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
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.setInterval;
	
	public class UploadMasterProcess extends Sprite
	{
		private var _uploader:Uploader;
		private var _log:TextField;
		private var _kdf:KDFile;
		private var _sockets:SocketManager;
		private var _renderer:Renderer;
		private var _rendererCanvas:Bitmap;
		private var _connected:Boolean;
		private const HOST:String = "raspberrypi.local";
		private const PORT:uint = 3001;
		public function UploadMasterProcess()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			initRenderer();
			initLog();
			initSocket();
			initUploader();
			_kdf = new KDFile();
			
			this.stage.addEventListener(Event.RESIZE, resize);
			resize(null);
		}
		private function initLog():void
		{
			_log = new TextField();
			_log.defaultTextFormat = new TextFormat("Consolas", 18, 0xffffff);
			this.addChild(_log);
			log("init");
		}
		private function initSocket():void
		{
			_sockets = new SocketManager(18760);
			//ソケットから受信
			_sockets.addEventListener(SocketManagerEvent.COMPLETE, function(e:SocketManagerEvent):void
			{
				log("received ("+e.client.id+") : "+e.bytesTotal+"byte");
				trace(e.data.length);
				var timeline:Timeline = _kdf.loadBinary(e.data);
				log(timeline.intervalSec);
				log(timeline.intervalMicroSec);
				_renderer.render(
					timeline.frames[0], 
					stage.stageWidth, stage.stageHeight, 
					timeline.generatorOptions
				);
				if(_connected) _uploader.upload(timeline);
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
		private function initUploader():void
		{
			_uploader = new Uploader(HOST, PORT);
			var connect:Function = function():void
			{
				log("connecting("+HOST+":"+PORT+")");
				_uploader.connect();
			}
			
			_uploader.addEventListener(UploaderEvent.CONNECT, function(e:UploaderEvent):void
			{
				log("connected");
				_connected = true;
			});
			_uploader.addEventListener(UploaderEvent.CLOSE, function(e:UploaderEvent):void
			{
				log("closed");
				_connected = false;
			});
			setInterval(function():void
			{
				if(_connected) return;
				connect();
			}, 1000*10);
			
			connect();
		}
		private function initRenderer():void
		{
			_renderer = new Renderer();
			_renderer.addEventListener(RendererEvent.COMPLETE, function(event:RendererEvent):void
			{
				_rendererCanvas.bitmapData = event.data;
			});
			_rendererCanvas = new Bitmap();
			this.addChild(_rendererCanvas);
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