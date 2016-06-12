# ローカルに入れる物
### local/pipush
./pipush hoge.c  
watcher/tempにプッシュする。  
watcherが動いていたらプッシュ完了時runが走る。  
### local/pipushc
./pipushc hoge.c  
pipush後に、コンソールを開いてくれるバージョン
### local/piquit
./piquit  
watcherで開始したプロセスを終了。  
# raspberryPIに入れる物
### pi/run
./run hoge.c  
./run ./hoge/hoge.c  
これでコンパイルと実行をしてくれる。
### pi/watcher
./watcher  
これで、screenが起動する。  
./temp/temp.cが変更されたらコンパイルして実行してくれる。  
inotifyとscreen必要。
