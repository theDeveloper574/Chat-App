const { Schema, model } = require("mongoose");

const messageModel = new Schema(
    {
        chatRoomId: { type: Schema.Types.ObjectId, ref: "chatRoom", required: true },
        sender: { type: Schema.Types.ObjectId, ref: "users", required: true },
        message: { type: String, required: true },
        isRead: { type: Boolean, default: false },
        readAt: { type: Date },
        createdAt: { type: Date, default: Date.now }
    }
);

const messageMod = model("messages", messageModel);
module.exports = messageMod;