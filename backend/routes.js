const express = require('express');
const { check } = require('express-validator');
const { getRates, refreshRates, autoRefreshRates } = require('./controllers');
const { validateApiKey } = require('./middlewares');

const router = express.Router();


router.get('/taux', getRates);


router.post('/taux/refresh', validateApiKey, refreshRates);


router.post('/taux/auto-refresh', validateApiKey, autoRefreshRates);

module.exports = router;