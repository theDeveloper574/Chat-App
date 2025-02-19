const { Schema, model } = require("mongoose");

const ChatRoomSchema = new Schema(
    {
        users: [{ type: Schema.Types.ObjectId, ref: "users" }],
        lastMessage: {
            text: { type: String, default: "" },
            sender: { type: Schema.Types.ObjectId, ref: "users" },
            createdAt: { type: Date, default: Date.now }
        },
        createdAt: { type: Date, default: Date.now }
    }
);

const ChatRoom = model("chatRoom", ChatRoomSchema);


module.exports = ChatRoom;