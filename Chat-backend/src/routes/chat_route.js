const route = require("express").Router();
const chatCon = require("./../controllers/chat_controller");


route.post("/checkChatRoom", chatCon.checkChatRoom);

route.post("/createChatRoom", chatCon.createChatRoom);
route.post("/sendMessage", chatCon.sendMessage);
route.get("/getUserChatList/:userId", chatCon.getUserChatList);
route.get("/getMessages/:chatRoomId", chatCon.getMessages);

module.exports = route;