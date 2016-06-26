package com.takumus.kaitenDisplay
{
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;

	public class Multi extends EventDispatcher
	{
		private var _generatorForSerial:Generator;
		private var _bitmapDatas:Vector.<BitmapData>;
		private var _serialIndex:int;
		private var _ledLength:int, _ledArrayLengthCM:Number, _centerRadiusCM:Number, _lineLength:uint, _blackIsTrue:Boolean;
		private var _data:String;
		public function Multi()
		{
			_bitmapDatas = new Vector.<BitmapData>();
			_generatorForSerial = new Generator();
			_generatorForSerial.addEventListener(GeneratorEvent.COMPLETE, generateNext);
		}
		public function clear():void
		{
			for(var i:int = 0; i < _bitmapDatas.length; i ++){
				_bitmapDatas[i].dispose();
				_bitmapDatas[i] = null;
			}
			_bitmapDatas.length = 0;
		}
		public function add(bitmapData:BitmapData):void
		{
			_bitmapDatas.push(bitmapData);
		}
		public function generateSerial(ledLength:uint, ledArrayLengthCM:Number, centerRadiusCM:Number, lineLength:uint, blackIsTrue:Boolean):void
		{
			_ledLength = ledLength;
			_ledArrayLengthCM = ledArrayLengthCM;
			_centerRadiusCM = centerRadiusCM;
			_lineLength = lineLength;
			_blackIsTrue = blackIsTrue;
			
			_serialIndex = 0;
			_data = "";
			generateNext(null);
		}
		private function generateNext(e:GeneratorEvent):void
		{
			if(_serialIndex > 0) _data += e.data+"\n";
			if(_bitmapDatas.length <= _serialIndex) {
				var me:MultiEvent = new MultiEvent(MultiEvent.COMPLETE);
				me._data = _data;
				dispatchEvent(me);
				return;
			}
			_generatorForSerial.generate(_bitmapDatas[_serialIndex], _ledLength, _ledArrayLengthCM, _centerRadiusCM, _lineLength, _blackIsTrue);
			_serialIndex ++;
		}
		public function get length():int
		{
			return _bitmapDatas.length;
		}
	}
}