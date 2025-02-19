const express = require("express");
const app = express();
const morgan = require("morgan");
const cors = require("cors");
const helmet = require("helmet");
const bodyParser = require("body-parser");
const mongoose = require("mongoose");
const Message = require("./models/message_model");
const ChatRoom = require("./models/chat_room_model");

const path = require('path');
// const http = require("http");
require("dotenv").config();
const mongoURI = process.env.MONGO_URI;

const http = require("http");
const { Server } = require("socket.io");

const server = http.createServer(app); // ✅ Use http.createServer
const io = new Server(server, {
    cors: {
        origin: "*",
        methods: ["GET", "POST"]
    },
    transports: ["websocket", "polling"],
});

app.use((req, res, next) => {
    req.io = io;
    next();
});
// Function to handle chat list
const handleChatList = (socket) => {
    socket.on('getUserChatList', async (userId) => {
        console.log("✅ User connected for chat list:", userId);
        try {
            const foundChats = await ChatRoom.find({ users: userId })
                .populate("users", "name avatar email");
            const unReadMessages = await Promise.all(
                foundChats.map(async (chat) => {
                    const unreadCount = await Message.countDocuments({
                        chatRoomId: chat._id,
                        sender: { $ne: userId },
                        isRead: false
                    });
                    return { ...chat.toObject(), unreadCount };
                })
            );

            // ✅ Emit chat list to user
            socket.emit('chatList', unReadMessages);
        } catch (ex) {
            console.error("❌ Error fetching chat list:", ex);
            socket.emit('chatListError', { message: ex.message });
        }
    });
    // ✅ Mark messages as read when the user opens a chat
    socket.on('markMessagesAsRead', async ({ chatRoomId, userId }) => {
        try {
            await Message.updateMany(
                { chatRoomId, sender: { $ne: userId }, isRead: false },
                { $set: { isRead: true, readAt: new Date() } }
            );

            console.log(`✅ Messages in chat ${chatRoomId} marked as read by ${userId}`);

            // ✅ Notify the other user in the chat that messages were read
            socket.to(chatRoomId).emit('messagesRead', { chatRoomId });

            // ✅ Update chat list after marking messages as read
            socket.emit('getUserChatList', userId);
        } catch (error) {
            console.error("❌ Error marking messages as read:", error);
        }
    });
};

// Function to handle single chat
const handleSingleChat = (socket) => {
    socket.on('joinRoom', async ({ chatRoomId, userId }) => {
        socket.join(chatRoomId);
        console.log(`✅ User joined room: ${chatRoomId}`);

        try {
            const messages = await Message.find({ chatRoomId }).sort({ createdAt: -1 });
            socket.emit('previousMessages', messages);

            // ✅ Mark unread messages as read when user joins the room
            await Message.updateMany(
                { chatRoomId, sender: { $ne: userId }, isRead: false },
                { $set: { isRead: true, readAt: new Date() } }
            ); const updatedMessages = await Message.updateMany(
                { chatRoomId, sender: { $ne: userId }, isRead: false },
                { $set: { isRead: true, readAt: new Date() } }
            );


            console.log(`✅ Messages in chat ${chatRoomId} marked as read by ${userId}`);

            // Notify the other user that messages were read
            io.to(chatRoomId).emit('messagesRead', { chatRoomId, userId });
        } catch (ex) {
            console.error("❌ Error fetching messages:", ex);
            socket.emit('previousMessagesError', { message: ex.message });
        }
    });

    socket.on('sendMessage', async (data) => {
        console.log("📩 New message received:", data);
        const { chatRoomId, sender, message } = data;

        try {
            const newMessage = new Message(data);
            await newMessage.save();

            // ✅ Update last message in ChatRoom
            await ChatRoom.findByIdAndUpdate(chatRoomId, {
                $set: {
                    lastMessage: { text: message, sender, createdAt: new Date() }
                }
            }, { new: true });

            // ✅ Emit to all users in the room
            io.to(chatRoomId).emit('receiveMessage', data);

            // ✅ Emit updated chat list globally
            io.emit('chatListUpdated', chatRoomId);
        } catch (ex) {
            console.error("❌ Error sending message:", ex);
            socket.emit('sendMessageError', { message: ex.message });
        }
    });
};
// Main Socket Connection
io.on('connection', (socket) => {
    console.log("🚀 New user connected:", socket.id);

    // Handle chat list and single chat separately
    handleChatList(socket);
    handleSingleChat(socket);

    socket.on('disconnect', () => {
        console.log("❌ User disconnected:", socket.id);
    });
});

app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());
app.use(helmet());
app.use(cors());
app.use(morgan("dev"));
// Serve the uploads folder
app.use('/uploads', express.static(path.join(__dirname, '../uploads')));
app.get("/", function (req, res) {
    const message = { "message": "Api works" };
    res.json(message);
});
// mongoose.connect();
mongoose.connect(mongoURI, {})
    .then(() => console.log("Database Connected Successfully"))
    .catch(err => console.error("Database Connection Error:", err));
// const PORT = process.env.PORT || 5002;
//user router
const userRouter = require("./routes/user_route");
app.use("/api/user", userRouter);
const chatRouter = require("./routes/chat_route");
app.use("/api/chat", chatRouter);
// const PORT = 5002;
// const PORT = process.env.PORT || 5002;
server.listen(5002, "0.0.0.0", () => {
    console.log("🚀 Server running on http://192.168.100.6:5002");
});
// server.listen(PORT, () => {
//     console.log(`🚀 Server running on http://192.168.100.6:${PORT}`);
// });
// app.listen(PORT, function () {
//     console.log("Server running on http://192.168.100.6: " + PORT);
// });
//http://192.168.100.6:5002/socket.io/?EIO=4&transport=polling