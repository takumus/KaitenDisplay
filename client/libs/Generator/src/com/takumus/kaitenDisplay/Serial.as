package com.takumus.kaitenDisplay
{
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;

	public class Serial extends EventDispatcher
	{
		private var _generator:Generator;
		private var _bitmapDatas:Vector.<BitmapData>;
		private var _serialIndex:int;
		private var _ledLength:int, _ledArrayLengthCM:Number, _centerRadiusCM:Number, _lineLength:uint, _blackIsTrue:Boolean;
		private var _data:String;
		private var _working:Boolean;
		public function Serial()
		{
			_bitmapDatas = new Vector.<BitmapData>();
			_generator = new Generator();
			_generator.addEventListener(GeneratorEvent.COMPLETE, generateNext);
			_generator.addEventListener(GeneratorEvent.ERROR, onError);
			setOptions(30, 30, 0, 30, true);
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
		public function setOptions(ledLength:uint, ledArrayLengthCM:Number, centerRadiusCM:Number, lineLength:uint, blackIsTrue:Boolean):void
		{
			if(_working) {
				error_working();
				return;
			}
			_ledLength = ledLength;
			_ledArrayLengthCM = ledArrayLengthCM;
			_centerRadiusCM = centerRadiusCM;
			_lineLength = lineLength;
			_blackIsTrue = blackIsTrue;
		}
		public function generate():void
		{
			if(_working) {
				error_working();
				return;
			}
			_working = true;
			_serialIndex = 0;
			_data = "";
			generateNext(null);
		}
		private function generateNext(e:GeneratorEvent):void
		{
			if(_serialIndex > 0) _data += e.data+"\n";
			if(_bitmapDatas.length <= _serialIndex) {
				var me:SerialEvent = new SerialEvent(SerialEvent.COMPLETE);
				me._data = _data;
				dispatchEvent(me);
				_working = false;
				return;
			}
			_generator.generate(_bitmapDatas[_serialIndex], _ledLength, _ledArrayLengthCM, _centerRadiusCM, _lineLength, _blackIsTrue);
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
			dispatchEvent(new SerialEvent(SerialEvent.ERROR));
		}
	}
}
import com.takumus.kaitenDisplay.Generator;

class GeneratorForParallel extends Generator{
	public var id:int;
}