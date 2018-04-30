import 'dart:typed_data';
import 'package:nuid/nuid.dart';


final MSG_RE  = new RegExp('\AMSG\s+([^\s]+)\s+([^\s]+)\s+(([^\s]+)[^\S\r\n]+)?(\d+)\r\n');
final OK_RE   = new RegExp('\A\+OK\s*\r\n');
final ERR_RE  = new RegExp('\A-ERR\s+(\'.+\')?\r\n');
final PING_RE = new RegExp('\APING\s*\r\n');
final PONG_RE = new RegExp('\APONG\s*\r\n');
final INFO_RE = new RegExp('\AINFO\s+([^\r\n]+)\r\n');

const INFO_OP = 'INFO';
const CONNECT_OP = 'CONNECT';
const PUB_OP = 'PUB';
const MSG_OP = 'MSG';
const SUB_OP = 'SUB';
const UNSUB_OP = 'UNSUB';
const PING_OP = 'PING';
const PONG_OP = 'PONG';
const OK_OP = '+OK';
const ERR_OP = '-ERR';
const MSG_END = '\n';
const _CRLF_ = '\r\n';
const _SPC_ = ' ';
const EMPTY = '';

const OK = OK_OP + _CRLF_;
const PING = PING_OP + _CRLF_;
const PONG = PONG_OP + _CRLF_;
const CRLF_SIZE = _CRLF_.length;
const OK_SIZE = OK.length;
const PING_SIZE = PING.length;
const PONG_SIZE = PONG.length;
const MSG_OP_SIZE = MSG_OP.length;
const ERR_OP_SIZE = ERR_OP.length;

String createInbox() => "_INBOX."+nuid.next();

class Msg {
  String subject;
  Uint8List data;
  int sid = 0;
  String reply;

  Msg(this.subject, this.data, this.sid, [this.reply]);

  static String pub(String subject, String payload, [String replyTo]){
    if(payload == null){
      payload = EMPTY;
    }
    int n = payload.length;

    String subjectAndReplyTo = subject;
    if(replyTo != null && replyTo.isNotEmpty){
      subjectAndReplyTo = '${subject} ${replyTo}';
    }

    return "PUB ${subjectAndReplyTo} ${replyTo} ${n}\r\n${payload}\r\n";
  }

  static String sub(String subject, int sid, [String queueGroup]){
    String subjectAndQueue = subject;
    if(queueGroup != null && queueGroup.isNotEmpty){
      subjectAndQueue = '${subject} ${queueGroup}';
    }
    return "SUB ${subjectAndQueue} ${sid}\r\n";
  }

  static String unsub(int sid, [int maxMsg]){
    String sidAndMax = '${sid}';
    if(maxMsg != null){
      sidAndMax = '${sid} ${maxMsg}';
    }
    return "UNSUB ${sidAndMax}\r\n";
  }
}
