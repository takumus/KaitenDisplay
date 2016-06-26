# Generator
### Generatorクラス
    var g:Generator = new Generator();
    //エラー
    g.addEventListener(GeneratorEvent.ERROR, trace);
    //生成完了
    g.addEventListener(GeneratorEvent.COMPLETE, function(e:GeneratorEvent):void
    {
      trace(e.data);
    });
    g.generate(bitmapData, LED個数, LED達の長さCM, 中心からの長さCM, 1回転を何分割するか);

### アニメーション生成用のSerialクラスもあるよ
    
    var s:Serial = new Serial();
    s.setOptions(LED個数, LED達の長さCM, 中心からの長さCM, 1回転を何分割するか);
    s.add(bitmapData1);//1コマ目
    s.add(bitmapData2);//2コマ目
    s.add(bitmapData3);//3コマ目
    s.add(bitmapData4);//4コマ目
    //エラー
    s.addEventListener(SerialEvent.ERROR, trace);
    //生成完了
    s.addEventListener(SerialEvent.COMPLETE, function(e:SerialEvent):void
    {
      trace(e.data);
    });
    s.generate();
