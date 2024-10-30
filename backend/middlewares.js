const API_KEY = process.env.API_KEY;


exports.validateApiKey = (req, res, next) => {
    const apiKey = req.headers['x-api-key'];
    if (apiKey && apiKey === API_KEY) {
        next();
    } else {
        res.status(403).json({ error: 'Invalid API key' });
    }
};


exports.errorHandler = (err, req, res, next) => {
    console.error(err.stack);
    res.status(500).json({ error: 'Internal Server Error' });
};