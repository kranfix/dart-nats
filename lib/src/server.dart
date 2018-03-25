import 'dart:html' show Url;

class Server {
  Url url;
  bool didConnect;
  int reconnects;

  Server(this.url){
    this.didConnect = false;
    this.reconnects = 0;
  }

  String toString(){
    return this.url.href;
  }
}
