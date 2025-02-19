const route = require('express').Router();
const userCon = require("../controllers/user_controller");
const authMiddleware = require("./../tokens/authMiddleware");
const updateImg = require("./../config/multer_config");
route.post("/register", updateImg.single("avatar"), userCon.register);
route.post("/login", userCon.login);
route.put("/:id", updateImg.single("avatar"), userCon.updateUser);
route.get("/", userCon.getUsers);

module.exports = route;