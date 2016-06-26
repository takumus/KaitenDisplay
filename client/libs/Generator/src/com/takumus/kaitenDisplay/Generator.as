package com.takumus.kaitenDisplay
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.system.WorkerDomain;
	import flash.utils.ByteArray;
	
	public class Generator extends EventDispatcher
	{
		[Embed(source="../../../worker/GeneratorWorker.swf", mimeType="application/octet-stream")]
		private static var WorkerChild:Class;
		
		private var _worker:Worker;
		private var _mainToWorker:MessageChannel;
		private var _workerToMain:MessageChannel;
		private var _imageBytes:ByteArray = new ByteArray();
		private var _working:Boolean;
		public function Generator()
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
			var ge:GeneratorEvent;
			if(props.status == 0){
				ge = new GeneratorEvent(GeneratorEvent.COMPLETE);
				ge._data = props.data;
			}else{
				ge = new GeneratorEvent(GeneratorEvent.ERROR);
			}
			_working = false;
			dispatchEvent(ge);
		}
		public function generate(bmd:BitmapData, ledLength:uint, ledArrayLengthCM:Number, centerRadiusCM:Number, lineLength:uint, blackIsTrue:Boolean):int
		{
			if(_working) return 1;
			_working = true;
			bmd.copyPixelsToByteArray(bmd.rect, _imageBytes);
			_mainToWorker.send({
				ledLength:ledLength,
				ledArrayLengthCM:ledArrayLengthCM,
				centerRadiusCM:centerRadiusCM,
				lineLength:lineLength,
				blackIsTrue:blackIsTrue,
				image:{
					width:bmd.width,
					height:bmd.height
				}
			});
			return 0;
		}
		public function get isWorking():Boolean
		{
			return _working;
		}
		public function close():void
		{
			_worker.terminate();
		}
	}
}