# as3 -> nodejs -> c -> gpio

nodeでtcpサーバーを立てて、as3でつなぐ。  
nodeはcで書いたgpio制御用アプリをchild_processで起動。  
as3からtcpでnodeに入ってきた文字をchild_processのstdinへ送る。