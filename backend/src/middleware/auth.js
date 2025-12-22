/**
 * Authentication Middleware
 * 
 * Verifies JWT tokens and attaches decoded user information to the request object.
 * This middleware is applied to all protected routes to ensure only authenticated
 * users can access them.
 * 
 * Token must be provided in the Authorization header as: "Bearer <token>"
 * 
 * On success, attaches req.user with: { userId, tenantId, role }
 */

const { verifyToken } = require('../utils/jwt');

const authenticate = async (req, res, next) => {
  try {
    // Get token from Authorization header
    const authHeader = req.headers.authorization;
    
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({
        success: false,
        message: 'No token provided'
      });
    }

    // Extract token (remove 'Bearer ' prefix)
    const token = authHeader.substring(7);

    // Verify token and decode payload
    const decoded = verifyToken(token);
    
    // Attach user info to request for use in subsequent middleware/controllers
    req.user = {
      userId: decoded.userId,
      tenantId: decoded.tenantId,
      role: decoded.role
    };

    next();
  } catch (error) {
    return res.status(401).json({
      success: false,
      message: error.message || 'Invalid or expired token'
    });
  }
};

module.exports = authenticate;
