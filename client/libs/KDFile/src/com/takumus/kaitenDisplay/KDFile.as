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
		public function load(file:File):Timeline
		{
			var fs:FileStream = new FileStream();
			fs.open(file, FileMode.READ);
			var ba:ByteArray = new ByteArray();
			fs.readBytes(ba);
			ba.uncompress();
			var timelineObject:Object = ba.readObject();
			var frames:Vector.<Frame> = new Vector.<Frame>();
			var goObject:Object = timelineObject.generatorOptions;
			var go:GeneratorOptions = new GeneratorOptions(goObject.ledLength, goObject.ledArrayLengthCM, goObject.centerRadiusCM, goObject.resolution, goObject.negative);
			for(var i:int = 0; i < timelineObject.frames.length; i ++){
				var frame:Frame = new Frame(timelineObject.frames[i]);
				frames.push(frame);
			}
			ba.clear();
			ba = null;
			return new Timeline(frames, go);
		}
		public function save(file:File, timeline:Timeline):void
		{
			var fs:FileStream = new FileStream();
			var ba:ByteArray = new ByteArray();
			var timelineObject:Object = {
				generatorOptions:{
					centerRadiusCM	:timeline.generatorOptions.centerRadiusCM,
					ledArrayLengthCM:timeline.generatorOptions.ledArrayLengthCM,
					ledLength		:timeline.generatorOptions.ledLength,
					negative		:timeline.generatorOptions.negative,
					resolution		:timeline.generatorOptions.resolution
				},
				frames:[]
			};
			for(var i:int = 0; i < timeline.frames.length; i ++){
				var frame:Frame = timeline.frames[i];
				timelineObject.frames.push(frame.data);
			}
			ba.writeObject(timelineObject);
			ba.compress();
			fs.open(file, FileMode.WRITE);
			fs.writeBytes(ba);
			fs.close();
			ba.clear();
			ba = null;
		}
	}
}