import 'dart:typed_data';

class Client {
  Client(){

  }

  
}

// States
const int AWAITING_CONTROL_LINE = 1,
  AWAITING_MSG_PAYLOAD = 2,
  MAX_CONTROL_LINE_SIZE = 1024;

class Parser {
  Client nc;
  Uint8List buf;

  int state;
  int needed;
  Map<String,dynamic> msgArg;

  Parser([this.nc]){
    this.reset();
  }

  reset() {
    this.buf = Uint8List();
    this.state = AWAITING_CONTROL_LINE;
    this.needed = 0;
    this.msgArg = Map();
  }

  /*
    Parses the wire protocol from NATS for the client
    and dispatches the subscription callbacks.
  */
  Future<> parse(Uint8List data) async {
    this.buf.addAll(data);

    var iter = this.buf.iterator;
    while (iter.moveNext()){
      if (this.state == AWAITING_CONTROL_LINE){
        String msg = MSG_RE.match(this.buf);
        if (msg == null || msg.isEmpty){
          try {
            subject, sid, _, reply, needed_bytes = msg.groups();
            this.msgArg["subject"] = subject;
            this.msgArg["sid"] = int(sid);
            if (reply != null){
              this.msgArg["reply"] = reply;
            } else {
              this.msgArg["reply"] = b'';
            }
            this.needed = int(needed_bytes)
            this.buf.removeRange(0, msg.end());
            this.state = AWAITING_MSG_PAYLOAD;
            continue;
          } catch {
            throw ErrProtocol("nats: malformed MSG");
          }
        }

        ok = OK_RE.match(this.buf);
        if (ok != null){
          // Do nothing and just skip.
          this.buf.removeRange(0, ok.end());
          continue;
        }

        err = ERR_RE.match(this.buf);
        if (err){
          err_msg = err.groups();
          yield from self.nc._process_err(err_msg)
          this.buf.removeRange(0, err.end());
          continue;
        }
          

        var ping = PING_RE.match(self.buf)
        if(ping){
          this.buf.removeRange(0, ping.end())
          yield from self.nc._process_ping()
          continue
        }

        var pong = PONG_RE.match(self.buf)
        if (pong) {
          del self.buf[:pong.end()]
          yield from self.nc._process_pong()
          continue
        }

        info = INFO_RE.match(self.buf)
        if (info){
          info_line = info.groups()[0]
          srv_info = json.loads(info_line.decode())
          self.nc._process_info(srv_info)
          del self.buf[:info.end()]
          continue
        }
          

        if (self.buf.length < MAX_CONTROL_LINE_SIZE and _CRLF_ in self.buf){
          // FIXME: By default server uses a max protocol
          // line of 1024 bytes but it can be tuned in latest
          // releases, in that case we won't reach here but
          // client ping/pong interval would disconnect
          // eventually.
          throw ErrProtocol("nats: unknown protocol");
        } else {
          // If nothing matched at this point, then it must
          // be a split buffer and need to gather more bytes.
          break;
        }
          

      } else if (this.state == AWAITING_MSG_PAYLOAD) {
        if (this.buf.length >= this.needed + CRLF_SIZE) {
            subject = self.msg_arg["subject"];
            sid = self.msg_arg["sid"];
            reply = self.msg_arg["reply"];

            // Consume msg payload from buffer and set next parser state.
            payload = bytes(self.buf[:self.needed])
            del self.buf[:self.needed + CRLF_SIZE]
            self.state = AWAITING_CONTROL_LINE
            return this.nc._process_msg(sid, subject, reply, payload)
        } else {
          // Wait until we have enough bytes in buffer.
          break;
        }
      }
    }
  }
}