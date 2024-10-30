const path = require('path');
const { exec } = require('child_process');
const { Client } = require('pg');

const scraperPath = path.join(__dirname, '../exchange-rate-scraper/scraper.js');

exports.getRates = async (req, res, next) => {
    const client = new Client({
        user: 'postgres',
        host: '127.0.0.1',
        database: 'gandyam',
        password: 'administer01',
        port: 5432,
    });

    try {
        await client.connect();
        const result = await client.query('SELECT * FROM exchange_rates');
        await client.end();
        res.json(result.rows);
    } catch (error) {
        next(error);
    }
};

exports.refreshRates = (req, res, next) => {
    exec(`node ${scraperPath}`, (error, stdout, stderr) => {
        if (error) {
            console.error('Error executing scraper:', error);
            return res.status(500).json({ error: 'Internal Server Error' });
        }
        console.log('Scraper output:', stdout);
        res.json({ message: 'Rates refreshed successfully' });
    });
};

exports.autoRefreshRates = (req, res, next) => {
    setInterval(() => {
        exec(`node ${scraperPath}`, (error, stdout, stderr) => {
            if (error) {
                console.error('Error executing scraper:', error);
                return;
            }
            console.log('Scraper output:', stdout);
        });
    }, 3600000); 
    res.json({ message: 'Auto-refresh started successfully' });
};