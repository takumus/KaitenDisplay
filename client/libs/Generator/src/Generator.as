package
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.system.WorkerDomain;
	import flash.utils.ByteArray;
	
	public class Generator extends Sprite
	{
		[Embed(source="../worker/bin/GeneratorWorker.swf", mimeType="application/octet-stream")]
		private static var WorkerChild:Class;
		
		private var _worker:Worker;
		private var _mainToWorker:MessageChannel;
		private var _workerToMain:MessageChannel;
		public function Generator()
		{
			var imageBytes:ByteArray = new ByteArray();
			imageBytes.shareable = true;
			
			_worker = WorkerDomain.current.createWorker(new WorkerChild());
			
			_mainToWorker = Worker.current.createMessageChannel(_worker);
			_workerToMain = _worker.createMessageChannel(Worker.current);
			
			_worker.setSharedProperty("mainToWorker", _mainToWorker);
			_worker.setSharedProperty("workerToMain", _workerToMain);
			_worker.setSharedProperty("imageBytes", imageBytes);
			
			_workerToMain.addEventListener(Event.CHANNEL_MESSAGE, getMessage);
			_worker.start();
			
			stage.addEventListener(MouseEvent.CLICK, function(e:Event):void
			{
				var bitmapData:BitmapData = new BitmapData(100, 100, false, 0x000000);
				bitmapData.copyPixelsToByteArray(bitmapData.rect, imageBytes);
				_mainToWorker.send({
					ledLength:48,
					ledArrayLengthCM:48,
					centerRadiusCM:0,
					lineLength:360,
					blackIsTrue:true,
					image:{
						width:bitmapData.width,
						height:bitmapData.height
					}
				});
			});
		}
		private function getMessage(event:Event):void
		{
			trace(_workerToMain.receive());
		}
	}
}