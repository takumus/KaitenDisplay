package com.takumus.kaitenDisplay
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	import flash.utils.CompressionAlgorithm;
	
	public class KDFile
	{
		public function KDFile()
		{
		}
		public function loadBinary(byteArray:ByteArray):Timeline
		{
			var timelineObject:Object = byteArray.readObject();
			var frames:Vector.<Frame> = new Vector.<Frame>();
			var goObject:Object = timelineObject.generatorOptions;
			var go:GeneratorOptions = new GeneratorOptions(goObject.ledLength, goObject.ledArrayLengthCM, goObject.centerRadiusCM, goObject.resolution, goObject.negative, goObject.threshold);
			for(var i:int = 0; i < timelineObject.frames.length; i ++){
				var frame:Frame = new Frame(timelineObject.frames[i]);
				frames.push(frame);
			}
			var tl:Timeline = new Timeline(frames, go);
			tl.intervalSec = timelineObject.intervalSec?timelineObject.intervalSec:2;
			trace(timelineObject.intervalSec);
			return tl;
		}
		public function loadFile(file:File):Timeline
		{
			var fs:FileStream = new FileStream();
			fs.open(file, FileMode.READ);
			var ba:ByteArray = new ByteArray();
			fs.readBytes(ba);
			
			ba.uncompress();
			
			return loadBinary(ba);
		}
		public function save(file:File, timeline:Timeline):void
		{
			var fs:FileStream = new FileStream();
			var ba:ByteArray = generateBinary(timeline);
			ba.compress();
			fs.open(file, FileMode.WRITE);
			fs.writeBytes(ba);
			fs.close();
			ba.clear();
			ba = null;
		}
		public function generateBinary(timeline:Timeline):ByteArray
		{
			var ba:ByteArray = new ByteArray();
			var timelineObject:Object = {
				generatorOptions:{
					centerRadiusCM	:timeline.generatorOptions.centerRadiusCM,
					ledArrayLengthCM:timeline.generatorOptions.ledArrayLengthCM,
					ledLength		:timeline.generatorOptions.ledLength,
					negative		:timeline.generatorOptions.negative,
					resolution		:timeline.generatorOptions.resolution
				},
				frames:[],
				intervalSec     :timeline.intervalSec
			};
			for(var i:int = 0; i < timeline.frames.length; i ++){
				var frame:Frame = timeline.frames[i];
				timelineObject.frames.push(frame.data);
			}
			ba.writeObject(timelineObject);
			
			return ba;
		}
	}
}