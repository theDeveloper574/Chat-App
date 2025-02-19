const ChatRoom = require("./../models/chat_room_model");
const Message = require("./../models/message_model");
const User = require("./../models/user_model");
const ChatController = {
    //create or get the chat room
    checkChatRoom: async function (req, res) {
        try {
            const { user1, user2 } = req.body;
            let chatRoom = await ChatRoom.findOne({
                users: { $all: [user1, user2] }
            });
            if (chatRoom) {
                return res.json({ success: true, data: chatRoom._id });
            } else {
                return res.json({ success: true, data: null });
            }
        } catch (ex) {
            return res.json({ success: false, message: ex.message });
        }
    },
    ///create chat room
    createChatRoom: async function (req, res) {
        try {
            const { user1, user2 } = req.body;

            const userOne = await User.findById(user1);
            const userTwo = await User.findById(user2);

            if (!userOne || !userTwo) {
                return res.json({ success: false, message: "One or both users do not exist" });
            }
            let chatRoom = await ChatRoom.findOne({
                users: { $all: [user1, user2] }
            });
            if (!chatRoom) {
                chatRoom = new ChatRoom({
                    users: [user1, user2],
                    createdAt: new Date(),
                });
                await chatRoom.save();
                return res.json({ success: true, data: chatRoom._id, message: "New Chat room created!" });
            }
            res.json({ success: true, data: chatRoom._id, message: "Chat room already exists" });
        } catch (ex) {
            return res.json({ success: false, message: ex.message });
        }
    },
    //send message
    sendMessage: async function (req, res) {
        try {
            const { chatRoomId, sender, message } = req.body;
            const newMessage = new Message({ chatRoomId, sender, message });
            await newMessage.save();
            // Update lastMessage in ChatRoom
            await ChatRoom.findByIdAndUpdate(chatRoomId, {
                lastMessage: {
                    text: message,
                    sender: sender,
                    createdAt: new Date(),
                }
            });
            req.io.to(chatRoomId).emit("newMessage", newMessage);
            return res.json({ success: true, data: newMessage, message: "Message send!" });
        } catch (ex) {
            return res.json({ success: false, message: ex.message });
        }
    },
    //show all chat list
    getUserChatList: async function (req, res) {
        try {
            const { userId } = req.params;
            //try to find all user chat list
            const foundChats = await ChatRoom.find({ users: userId }).populate("users", "name avatar email");
            return res.json({ success: true, data: foundChats, message: "user chat list" });
        } catch (ex) {
            return res.json({ success: false, message: ex.message });
        }
    },
    // get user message
    getMessages: async function (req, res) {
        try {
            const { chatRoomId } = req.params;
            //get messages
            const messages = await Message.find({ chatRoomId });
            return res.json({ success: true, data: messages, message: "Messages retrieved" });
        } catch (ex) {
            return res.json({ success: false, message: ex.message });
        }
    }
};



module.exports = ChatController;