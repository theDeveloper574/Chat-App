const jwt = require("jsonwebtoken");

const authMiddleware = (req, res, next) => {
    const token = req.header("Authorization");

    if (!token) {
        return res.status(401).json({ success: false, message: "Access denied. No token provided." });
    }

    try {
        const decoded = jwt.verify(token, process.env.TOKEN_KEY);
        req.user = decoded; // Attach user info to request
        next();
    } catch (error) {
        console.log(error);
        return res.status(401).json({ success: false, message: "Invalid or expired token." });
    }
};
module.exports = authMiddleware;