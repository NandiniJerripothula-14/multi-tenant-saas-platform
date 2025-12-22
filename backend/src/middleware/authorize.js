/**
 * Role-Based Authorization Middleware
 * 
 * Checks if the authenticated user has one of the required roles to access a route.
 * Must be used after the authenticate middleware.
 * 
 * Supported roles:
 * - super_admin: Full system access across all tenants
 * - tenant_admin: Full access within their tenant
 * - user: Limited access to their own resources
 * 
 * Usage:
 *   router.get('/admin-only', authenticate, authorize('super_admin'), handler)
 *   router.get('/admin-or-manager', authenticate, authorize('super_admin', 'tenant_admin'), handler)
 * 
 * @param {...string} allowedRoles - One or more role names that are permitted
 * @returns {Function} Express middleware function
 */
const authorize = (...allowedRoles) => {
  return (req, res, next) => {
    // Ensure user is authenticated
    if (!req.user) {
      return res.status(401).json({
        success: false,
        message: 'Authentication required'
      });
    }

    // Check if user's role is in the allowed list
    if (!allowedRoles.includes(req.user.role)) {
      return res.status(403).json({
        success: false,
        message: 'Insufficient permissions'
      });
    }

    next();
  };
};

module.exports = authorize;
