const express = require('express');
const router = express.Router();
const controllers = require('../app/controllers');
const middlewares = require('../app/middlewares');

const { ROUTE_NAMES } = CONSTANTSs;

const {
    middleware: { cognitoAuthHandler }
} = require('@respond-io/auth');

const authOptions = {
    cognito: {
        tokenUse: 'id',
        keysToVerify: ['user_id', 'role', 'email', 'session_id'],
        debug: process.env.APP_ENV === 'local'
    }
};

router.get(
    '',
    [
        middlewares.http.service.initializeRouteName(ROUTE_NAMES.GET_INTEGRATIONS),
        cognitoAuthHandler(authOptions.cognito),
        middlewares.http.service.web,
        middlewares.http.service.blockFrozenOrganization,
        middlewares.http.service.acl.getSpaceUser,
        middlewares.http.service.acl.checkRouteAccess
    ],
    (req, res, next) => new controllers.IntegrationController(req, res, next).getIntegrations()
);

router.delete(
    '/:id',
    [
        middlewares.http.service.initializeRouteName(ROUTE_NAMES.DELETE_INTEGRATION),
        cognitoAuthHandler(authOptions.cognito),
        middlewares.http.service.web,
        middlewares.http.service.blockFrozenOrganization,
        middlewares.http.service.acl.getSpaceUser,
        middlewares.http.service.acl.checkRouteAccess
        // todo: check middlewares
    ],
    (req, res, next) => new controllers.IntegrationController(req, res, next).deleteIntegration()
);

module.exports = router;