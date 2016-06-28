package com.takumus.kaitenDisplay
{
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.system.WorkerDomain;
	import flash.utils.ByteArray;

	public class Renderer extends EventDispatcher
	{
		[Embed(source="../../../worker/RendererWorker.swf", mimeType="application/octet-stream")]
		private static var WorkerChild:Class;
		
		private var _worker:Worker;
		private var _mainToWorker:MessageChannel;
		private var _workerToMain:MessageChannel;
		private var _imageBytes:ByteArray = new ByteArray();
		private var _working:Boolean;
		public function Renderer()
		{
			_imageBytes.shareable = true;
			
			_worker = WorkerDomain.current.createWorker(new WorkerChild());
			_mainToWorker = Worker.current.createMessageChannel(_worker);
			_workerToMain = _worker.createMessageChannel(Worker.current);
			
			_worker.setSharedProperty("mainToWorker", _mainToWorker);
			_worker.setSharedProperty("workerToMain", _workerToMain);
			_worker.setSharedProperty("imageBytes", _imageBytes);
			
			_workerToMain.addEventListener(Event.CHANNEL_MESSAGE, getMessage);
			_worker.start();
		}
		private function getMessage(event:Event):void
		{
			var props:Object = _workerToMain.receive();
			var re:RendererEvent;
			if(props.status == 0){
				var bitmapData:BitmapData = new BitmapData(props.image.width, props.image.height, false, 0x000000);
				_imageBytes.position = 0;
				bitmapData.setPixels(bitmapData.rect, _imageBytes);
				re = new RendererEvent(RendererEvent.COMPLETE);
				re._data = bitmapData;
				dispatchEvent(re);
			}else{
				re = new RendererEvent(RendererEvent.ERROR);
				re._data = null;
				dispatchEvent(re);
			}
			_working = false;
		}
		public function render(frame:Frame, width:Number, height:Number, generatorOptions:GeneratorOptions):void
		{
			if(_working) {
				dispatchEvent(new RendererEvent(RendererEvent.ERROR));
				return;
			}
			_working = true;
			_mainToWorker.send({
				frame:frame.data,
				width:width,
				height:height,
				generatorOptions:{
					centerRadiusCM:generatorOptions.centerRadiusCM,
					ledArrayLengthCM:generatorOptions.ledArrayLengthCM,
					ledLength:generatorOptions.ledLength,
					negative:generatorOptions.negative,
					resolution:generatorOptions.resolution
				}
			});
		}
	}
}