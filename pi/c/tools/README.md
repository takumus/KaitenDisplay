# ローカルに入れる物
### local/pipush
    ./pipush hoge.c  
hoge.cをラズパイに送ってコンパイル＆実行する。
### local/piquit
    ./piquit  
./pipushで開始したプロセスが何らかの原因で終了しなかった場合、  
このコマンドで終了できるはず。  
※実は`./pipush`すると、最初に`./piquit`が走るのです。  
どんどん`./pipush`しちゃってください。
# raspberryPIに入れる物
### pi/run
    ./run hoge.c  
    ./run ./hoge/hoge.c  
これでコンパイルと実行をしてくれる。
### pi/runner
これはローカルの`./pipush`用のコマンドです。

### pi/quit_runner
runnerを殺すコマンドです。  
これもローカルの`./piquit`用です。

# 導入方法
今のところ自分用に作ったので、使い勝手悪いです。  
ラズパイ側でscreenを使いますので入れておきましょう。  
`./pi`をラズパイの何処かにおいてください。  
`./local`は、ローカルの何処かにおいてください。  
`./local`の中の`pipush`,`piquit`は`TARGET_PATH`,`RUNNER_PATH`,`QUIT_RUNNER_PATH`を編集して下さい。  
