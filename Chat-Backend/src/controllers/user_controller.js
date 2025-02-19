const User = require("../models/user_model");
const bcrypt = require("bcrypt");

const jwt = require("jsonwebtoken");
const { createSecretToken } = require("../tokens/token_generation");
const UserController = {
    //fetch all user
    getUsers: async function (req, res) {
        try {

            const users = await User.find({}, { password: 0 }).sort({ createdAt: -1 });
            return res.json({ success: true, data: users });
        } catch (ex) {
            return res.json({ success: false, message: ex.message });
        }
    },
    ///register new user
    register: async function (req, res) {
        try {
            const reqData = req.body;
            if (req.file) {
                reqData.avatar = `uploads/${req.file.filename}`;
            }
            const checkUser = await User.findOne({
                $or: [{ email: reqData.email }, { userName: reqData.userName }]
            });
            if (checkUser) {
                return res.json({
                    success: false,
                    message: checkUser.email === reqData.email
                        ? "This email is already taken"
                        : "This username is already taken"
                });
            }
            const newUser = new User(reqData);
            await newUser.save();
            const token = createSecretToken(newUser._id);
            return res.json({ success: true, data: newUser, token: token, message: "User Created" });
        } catch (ex) {
            console.log(ex);
            return res.json({ success: false, message: ex });
        }
    },
    login: async function (req, res) {
        try {
            const { user, password } = req.body;
            // const foundUser = await User.findOne({ email: email });
            const foundUser = await User.findOne(
                {
                    $or: [{ email: user }, { userName: user }]
                }
            );
            if (!foundUser) {
                return res.json({ success: false, message: "User not found!" });
            }
            const passwordFound = bcrypt.compareSync(password, foundUser.password);
            if (!passwordFound) {
                return res.json({ success: false, message: "Enter correct password" });
            }
            // 🎫 Generate JWT Token
            const token = jwt.sign({
                id: foundUser._id,
                name: foundUser.name,
                avatar: foundUser.avatar,
                email: foundUser.email,
                userName: foundUser.userName
            }, process.env.TOKEN_KEY, { expiresIn: "15m" });
            return res.json({
                success: true, data: {
                    ...foundUser.toObject(),
                    token: token
                }, message: "User Login"
            });

        } catch (ex) {
            res.json({ success: false, message: ex });
        }
    },
    //upudate user profile
    updateUser: async function (req, res) {
        try {
            const userId = req.params.id;
            const updatedReq = { ...req.body };
            // Check if the username is already taken (excluding the current user)
            if (updatedReq.userName) {
                const existingUser = await User.findOne({
                    userName: updatedReq.userName,
                    _id: { $ne: userId } // Exclude the current user
                });

                if (existingUser) {
                    return res.json({ success: false, message: "Username is already taken!" });
                }
            }
            if (req.file) {
                updatedReq.avatar = `uploads/${req.file.filename}`;
            }
            const updateUser = await User.findOneAndUpdate(
                {
                    _id: userId,
                },
                updatedReq,
                {
                    new: true
                }
            );
            if (!updateUser) {
                return res.json({ success: false, message: "No user found!" });
            }
            return res.json({ success: true, data: updateUser, message: "User Updated!" });

        } catch (ex) {
            return res.json({ success: false, message: ex, });
        }
    }
}


module.exports = UserController;