class Srv {
  Uri uri;
  bool didConnect;
  bool discovered = false;
  int reconnects = 0;
  var lastAttempt = null;

  Srv(String uri){
    this.uri = Uri.parse(uri);
  }

  String toString(){
    return this.uri.toString();
  }
}
