# run
./run hoge.c  
./run ./hoge/hoge.c  
これでコンパイルと実行をしてくれる。
# watcher
./watcher  
これで、screenが起動する。  
./temp/temp.cが変更されたらコンパイルして実行してくれる。  
inotifyとscreen必要。