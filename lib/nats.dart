/*var net = require('net'),
    tls = require('tls'),
    url = require('url'),
    util = require('util'),
    events = require('events'),
    nuid = require('nuid');*/
import 'dart:html' show Url;
import 'dart:async' show Timer;
import 'package:nuid/nuid.dart';
import 'package:nats/src/const.dart';
import 'package:nats/src/errors.dart';
import 'package:nats/src/server.dart';

String createInbox() => "_INBOX."+nuid.next();

class Client {
  Map options;
  String user;
  String pass;
  List<Server> servers;
  Server currentServer;
  Url url;

  int reconnects;
  bool closed;
  bool wasConnected = false, reconnecting = false;

  Client(Map<String,dynamic> opts){
    //$$$events.EventEmitter.call(this);

    this.options = {
        'verbose': false,
        'pedantic': false,
        'reconnect': true,
        'maxReconnectAttempts': DEFAULT_MAX_RECONNECT_ATTEMPTS,
        'reconnectTimeWait': DEFAULT_RECONNECT_TIME_WAIT,
        'encoding': 'utf8',
        'tls': false,
        'waitOnFirstConnect': false,
        'pingInterval': DEFAULT_PING_INTERVAL,
        'maxPingOut': DEFAULT_MAX_PING_OUT,
        'useOldRequestStyle': false,
        'url': DEFAULT_URI,

    };
    this.parseOptions(opts);
    this.initState();
    this.createConnection();
  }

  initState(){

  }

  createConnection(){

  }

  parseOptions(Map<String,dynamic> opts){

  }

  assignOption(Map<String,dynamic> opts, String prop, [String assign]){
    if(assign == null){
      assign = prop;
    }
    if(opts.containsKey(prop)) {
        this.options[assign] = opts[prop];
    }
  }

  selectServer() {
      Server server = this.servers[0];
      this.servers.removeAt(0);

      // Place in client context.
      this.currentServer = server;
      this.url = server.url;
      if ('auth' in server.url && !!server.url.auth) {
          var auth = server.url.auth.split(':');
          if (auth.length != 1) {
              if (!this.options.containsKey('user')) {
                  this.user = auth[0];
              }
              if (!this.options.containsKey('pass')) {
                  this.pass = auth[1];
              }
          } else {
              if (!this.options.containsKey('token')) {
                  this.token = auth[0];
              }
          }
      }
      this.servers.add(server);
  }

  numSubscriptionsn() {
      //$$$return Object.keys(this.subs).length;
  }

  _reconnect() {
      if (this.closed) {
          return;
      }
      this.reconnects += 1;
      this.createConnection();
      if (this.currentServer.didConnect) {
          //$$$this.emit('reconnecting');
      }
  }

  _scheduleReconnect() {
      // Just return if no more servers
      if (this.servers.length == 0) {
          return;
      }
      // Don't set reconnecting state if we are just trying
      // for the first time.
      if (this.wasConnected) {
          this.reconnecting = true;
      }
      // Only stall if we have connected before.
      num wait = 0;
      if (this.servers[0].didConnect) {
          wait = this.options['reconnectTimeWait'];
      }
      var timer = new Timer(
        new Duration(milliseconds: wait),
        () {
          this._reconnect();
        });
  }
}
