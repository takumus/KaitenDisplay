package com.takumus.kaitenDisplay
{
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;

	public class SerialGenerator extends EventDispatcher
	{
		private var _generator:Generator;
		private var _bitmapDatas:Vector.<BitmapData>;
		private var _serialIndex:int;
		private var _ledLength:int, _ledArrayLengthCM:Number, _centerRadiusCM:Number, _resolution:uint, _negative:Boolean;
		private var _data:Vector.<Frame>;
		private var _working:Boolean;
		public function SerialGenerator()
		{
			_bitmapDatas = new Vector.<BitmapData>();
			_generator = new Generator();
			_generator.addEventListener(GeneratorEvent.COMPLETE, generateNext);
			_generator.addEventListener(GeneratorEvent.ERROR, onError);
			_data = new Vector.<Frame>();
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
		public function setOptions(options:GeneratorOptions):void
		{
			if(_working) {
				error_working();
				return;
			}
			_ledLength = options.ledLength;
			_ledArrayLengthCM = options.ledArrayLengthCM;
			_centerRadiusCM = options.centerRadiusCM;
			_resolution = options.resolution;
			_negative = options.negative;
		}
		public function generate():void
		{
			if(_working) {
				error_working();
				return;
			}
			_working = true;
			_serialIndex = 0;
			_data.length = 0;
			generateNext(null);
		}
		private function generateNext(e:GeneratorEvent):void
		{
			if(_serialIndex > 0) _data.push(e.data);
			if(_bitmapDatas.length <= _serialIndex) {
				var me:SerialGeneratorEvent = new SerialGeneratorEvent(SerialGeneratorEvent.COMPLETE);
				me._data = new Timeline(_data);
				dispatchEvent(me);
				_working = false;
				return;
			}
			_generator.generate(_bitmapDatas[_serialIndex], _ledLength, _ledArrayLengthCM, _centerRadiusCM, _resolution, _negative);
			_serialIndex ++;
		}
		public function get length():int
		{
			return _bitmapDatas.length;
		}
		
		private function error_working():void
		{
			throw new Error("working");
		}
		private function onError(event:GeneratorEvent):void
		{
			_working = false;
			dispatchEvent(new SerialGeneratorEvent(SerialGeneratorEvent.ERROR));
		}
	}
}