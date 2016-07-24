package
{
	import com.takumus.kaitenDisplay.Uploader;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.LocalConnection;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	
	public class UploadMaster extends Sprite
	{
		private var _uploader:Uploader;
		private var _connection:LocalConnection;
		private var _log:TextField;
		public function UploadMaster()
		{
			_connection = new LocalConnection();
			_connection.client = {
				onData:onData
			};
			_log = new TextField();
			this.addChild(_log);
			this.stage.addEventListener(Event.RESIZE, resize);
			resize(null);
		}
		private function onData(byteArray:ByteArray):void
		{
			
		}
		private function resize(e:Event):void
		{
			_log.width = stage.stageWidth;
			_log.height = stage.stageHeight;
		}
	}
}