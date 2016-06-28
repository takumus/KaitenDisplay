package com.takumus.kaitenDisplay
{
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;

	public class GeneratorForAnimate extends EventDispatcher
	{
		private var _stage:MovieClip;
		private var _width:Number, _height:Number;
		private var _backgroundColor:int;
		private var _generator:Generator;
		
		private var _frame:int;
		private var _frameLength:int;
		
		private var _options:GeneratorOptions;
		
		private var _frames:Vector.<Frame>;
		public function GeneratorForAnimate(stage:MovieClip, width:Number, height:Number, backgroundColor:uint = 0xffffff)
		{
			_stage = stage;
			_width = width;
			_height = height;
			_backgroundColor = backgroundColor;
			_generator = new Generator();
			_frames = new Vector.<Frame>();
			_generator.addEventListener(GeneratorEvent.COMPLETE, generateNext);
		}
		public function generate(options:GeneratorOptions):void
		{
			_options = options;
			_frames.length = 0;
			_frame = 1;
			_frameLength = _stage.framesLoaded;
			generateNext(null);
		}
		private function generateNext(e:GeneratorEvent):void
		{
			if(e) _frames.push(e.data);
			if(_frame > _frameLength){
				var timeline:Timeline = new Timeline(_frames);
				var ge:GeneratorForAnimateEvent = new GeneratorForAnimateEvent(GeneratorForAnimateEvent.COMPLETE);
				ge._data = timeline;
				dispatchEvent(ge);
				return;
			}
			_stage.gotoAndStop(_frame);
			
			var bitmapData:BitmapData = new BitmapData(_width, _height, false, _backgroundColor);
			bitmapData.draw(_stage);
			_generator.generate(bitmapData, _options);
			bitmapData.dispose();
			trace(_frame);
			_frame ++;
		}
	}
}