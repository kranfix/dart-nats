class Server {
  Uri uri;
  bool didConnect;
  int reconnects;

  Server(String url){
    uri = Uri.parse(url);
    this.didConnect = false;
    this.reconnects = 0;
  }

  String toString(){
    return this.uri.toString();
  }
}
