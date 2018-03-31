import 'dart:typed_data';

const MSG = r"^MSG\s+([^\s\r\n]+)\s+([^\s\r\n]+)\s+(([^\s\r\n]+)[^\S\r\n]+)?(\d+)\r\n",
  OK = "^\+OK\s*\r\n",
  ERR = "^-ERR\s+('.+')?\r\n",
  PING = "^PING\r\n",
  PONG = "^PONG\r\n",
  INFO = "^INFO\s+([^\r\n]+)\r\n",
  SUBRE = "^SUB\s+([^\r\n]+)\r\n",

  EMPTY = '',
  SPC = ' ',
  CR_LF = '\r\n',
  CR_LF_LEN = CR_LF.length;

class Msg {
  String subject;
  String reply;
  Uint8List data;


  Msg(this.subject, this.data, [this.reply]){

  }

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
