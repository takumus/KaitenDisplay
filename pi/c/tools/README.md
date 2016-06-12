# pi/run
./run hoge.c  
./run ./hoge/hoge.c  
これでコンパイルと実行をしてくれる。
# pi/watcher
./watcher  
これで、screenが起動する。  
./temp/temp.cが変更されたらコンパイルして実行してくれる。  
inotifyとscreen必要。
# local/push
./push hoge.c
watcher/tempにプッシュする。  
watcherが動いていたらプッシュ完了時runが走る。