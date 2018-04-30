/**
 * Constants
 */
const VERSION = '0.8.6';

const DEFAULT_PORT = 4222;
const DEFAULT_PRE = 'nats://localhost:';
final DEFAULT_URI = DEFAULT_PRE + DEFAULT_PORT;

const MAX_CONTROL_LINE_SIZE = 512;

// Parser state
const AWAITING_CONTROL = 0;
const AWAITING_MSG_PAYLOAD = 1;

// Reconnect Parameters, 2 sec wait, 10 tries
const DEFAULT_RECONNECT_TIME_WAIT    = 2 * 1000;
const DEFAULT_MAX_RECONNECT_ATTEMPTS = 10;

// Ping interval
const DEFAULT_PING_INTERVAL = 2 * 60 * 1000; // 2 minutes
const DEFAULT_MAX_PING_OUT = 2;

// Protocol
//CONTROL_LINE = /^(.*)\r\n/, // TODO: remove / never used
const CRLF = '\r\n';
const EMPTY = '';
const SPC = ' ';

// Protocol
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

// Responses
const OK = OK_OP + CRLF;
const PING = PING_OP + CRLF;
const PONG = PONG_OP + CRLF;

// Sizes
const CRLF_SIZE = CRLF.length;
const OK_SIZE = OK.length;
const PING_SIZE = PING.length;
const PONG_SIZE = PONG.length;
const MSG_OP_SIZE = MSG_OP.length;
const ERR_OP_SIZE = ERR_OP.length;

// Regular Expressions
final MSG_RE  = new RegExp('\AMSG\s+([^\s]+)\s+([^\s]+)\s+(([^\s]+)[^\S\r\n]+)?(\d+)\r\n');
final OK_RE   = new RegExp('\A\+OK\s*\r\n');
final ERR_RE  = new RegExp('\A-ERR\s+(\'.+\')?\r\n');
final PING_RE = new RegExp('\APING\s*\r\n');
final PONG_RE = new RegExp('\APONG\s*\r\n');
final INFO_RE = new RegExp('\AINFO\s+([^\r\n]+)\r\n');