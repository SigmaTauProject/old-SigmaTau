module galactic_msg_.msg_template_;

import std.experimental.logger;
import cst_;


mixin template  MsgTemplate(){
	alias Msg = typeof(this);
	static Msg opCall() {
		return new Msg;
	}
	static Msg opCall(UnknownMsg msg) {
		return Msg(msg.msgData);
	}
	static Msg opCall(const(ubyte)[] msgData) {
		assert(msgData[0] == msgData.length);
		msgData.log;
		type.log;
		return msgData[2..$].deserialize!(Msg, Endian.littleEndian, ubyte);
	}
	
	@property
	const(ubyte)[] msgData() {
		auto data = this.serialize!(Endian.littleEndian, ubyte);
		type.log;
		data.log;
		data = [(data.length+2).cst!ubyte, type.cst!ubyte]~data;
		assert(data.length == data[0]);
		return data;
	}
	alias msgData this;
}


