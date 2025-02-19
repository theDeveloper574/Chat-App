const { Schema, model } = require("mongoose");
const bcrypt = require("bcrypt");
const userSchema = new Schema(
    {
        userName: { type: String, required: true, unique: true },
        name: { type: String, default: "" },
        avatar: { type: String, default: "" },
        email: { type: String, required: true, unique: true },
        password: { type: String, required: true },
        createdAt: { type: Date },
        updatedAt: { type: Date },
    }
);
userSchema.pre("save", function (next) {
    this.createdAt = new Date();
    this.updatedAt = new Date();
    const salt = bcrypt.genSaltSync(10);
    const hash = bcrypt.hashSync(this.password, salt);
    this.password = hash;
    next();
});
userSchema.pre(['update', "findOneAndUpdate", "updateOne"], function (next) {
    const update = this.getUpdate();
    this.updatedAt = new Date();
    next();
});

const User = model("users", userSchema);
module.exports = User;