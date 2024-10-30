const puppeteer = require('puppeteer');
const fs = require('fs');
const { Client } = require('pg');

async function delay(time) {
    return new Promise(function(resolve) { 
        setTimeout(resolve, time);
    });
}

async function scrapeTapTapSend() {
    console.log('Scraping TapTapSend...');
    try {
        const url = 'https://www.taptapsend.com/';
        console.log('Launching browser...');
        const browser = await puppeteer.launch();
        const page = await browser.newPage();
        console.log('Navigating to page:', url);
        await page.goto(url, { waitUntil: 'networkidle2' });

       
        const pLimit = (await import('p-limit')).default;
        const limit = pLimit(5); 

        
        const sourceCountries = await page.evaluate(() => {
            const options = Array.from(document.querySelectorAll('#origin-currency option'));
            return options.map(option => ({ value: option.value, text: option.textContent.trim() }));
        });

        const rates = {};
        const tasks = [];

        for (const source of sourceCountries) {
            if (!source.value) continue; 

            tasks.push(limit(async () => {
                
                await page.select('#origin-currency', source.value);

                
                const selectedSourceCountry = await page.evaluate(() => {
                    const sourceCountry = document.querySelector('#origin-currency');
                    return sourceCountry ? sourceCountry.value : null;
                });
                console.log(`Selected source country: ${selectedSourceCountry}`);

                
                await delay(1000);

                const destinationCountries = await page.evaluate(() => {
                    const options = Array.from(document.querySelectorAll('#destination-currency option'));
                    return options.map(option => ({ value: option.value, text: option.textContent.trim() }));
                });

                console.log(`Destination countries for ${source.text}:`, destinationCountries);

                for (const destination of destinationCountries) {
                    console.log(`Scraping rate for ${source.text} to ${destination.text}...`);

                    await page.select('#destination-currency', destination.value);

                   const selectedDestinationCountry = await page.evaluate(() => {
                        const destinationCountry = document.querySelector('#destination-currency');
                        return destinationCountry ? destinationCountry.value : null;
                    });
                    console.log(`Selected destination country: ${selectedDestinationCountry}`);

                    await page.waitForSelector('#fxRateText');

                    await delay(2000);

                   const rateText = await page.evaluate(() => {
                        const rateElement = document.querySelector('#fxRateText');
                        return rateElement ? rateElement.textContent : null;
                    });

                    console.log('Rate text:', rateText);

                    if (!rateText) {
                        console.error(`Rate element not found for ${source.text} to ${destination.text}`);
                        continue;
                    }

                    const rateMatch = rateText.match(/(\d+\.\d+)\s*([A-Z]{3})/i);
                    console.log('Rate match:', rateMatch);
                    const rate = rateMatch ? rateMatch[1] : null;
                    const currency = rateMatch ? rateMatch[2] : null;
                    console.log('Extracted rate:', rate);
                    console.log('Extracted currency:', currency);

                    if (rate) {
                        rates[`${source.text}_to_${destination.text}`] = `${rate} ${currency}`;
                    }
                }
            }));
        }

        await Promise.all(tasks);

        await browser.close();
        return rates;
    } catch (error) {
        console.error('Error scraping TapTapSend:', error);
        return {};
    }
}

async function scrapeTransfertChapChap() {
    console.log('Scraping TransfertChapChap...');
    try {
        const url = 'https://transfertchapchap.com/';
        console.log('Launching browser...');
        const browser = await puppeteer.launch();
        const page = await browser.newPage();
        console.log('Navigating to page:', url);
        await page.goto(url, { waitUntil: 'networkidle2', timeout: 120000 }); 

        const sourceCountries = await page.evaluate(() => {
            const options = Array.from(document.querySelectorAll('#source-country option'));
            return options.map(option => ({ value: option.value, text: option.textContent.trim(), currency: option.getAttribute('data-country-code-monnaie') }));
        });

        const rates = {};

        for (const source of sourceCountries) {
            if (!source.value) continue; 

            await page.select('#source-country', source.value);

            const selectedSourceCountry = await page.evaluate(() => {
                const sourceCountry = document.querySelector('#source-country');
                return sourceCountry ? sourceCountry.value : null;
            });
            console.log(`Selected source country: ${selectedSourceCountry}`);

            await delay(1000);

            const destinationCountries = await page.evaluate(() => {
                const options = Array.from(document.querySelectorAll('#destination-country option'));
                return options.map(option => ({ value: option.value, text: option.textContent.trim(), currency: option.getAttribute('data-country-code-monnaie') }));
            });

            console.log(`Destination countries for ${source.text}:`, destinationCountries);

            for (const destination of destinationCountries) {
                console.log(`Scraping rate for ${source.text} to ${destination.text}...`);

              await page.select('#destination-country', destination.value);

               const selectedDestinationCountry = await page.evaluate(() => {
                    const destinationCountry = document.querySelector('#destination-country');
                    return destinationCountry ? destinationCountry.value : null;
                });
                console.log(`Selected destination country: ${selectedDestinationCountry}`);

                await page.waitForSelector('#dest-text');

               await delay(2000);

              const rateText = await page.evaluate(() => {
                    const rateElement = document.querySelector('#dest-text');
                    return rateElement ? rateElement.textContent : null;
                });

                console.log('Rate text:', rateText);

                if (!rateText) {
                    console.error(`Rate element not found for ${source.text} to ${destination.text}`);
                    continue;
                }

                const rateMatch = rateText.match(new RegExp(`(\\d+\\.\\d+)\\s*${destination.currency}`, 'i'));
                console.log('Rate match:', rateMatch);
                const rate = rateMatch ? rateMatch[1] : null;
                console.log('Extracted rate:', rate);

                if (rate) {
                    rates[`${source.text}_to_${destination.text}`] = rate;
                }
            }
        }

        await browser.close();
        return rates;
    } catch (error) {
        console.error('Error scraping TransfertChapChap:', error);
        return {};
    }
}

async function scrapeGandyamPay() {
    console.log('Scraping GandyamPay...');
    try {
        const url = 'https://gandyampay.com/';
        console.log('Launching browser...');
        const browser = await puppeteer.launch();
        const page = await browser.newPage();
        console.log('Navigating to page:', url);
        await page.goto(url, { waitUntil: 'networkidle2' });

        await page.click('#rfs-btn');

       const destinationCountries = await page.evaluate(() => {
            const options = Array.from(document.querySelectorAll('.ReactFlagsSelect-module_selectOptions__3LNBJ li'));
            return options.map(option => ({ value: option.id, text: option.querySelector('.ReactFlagsSelect-module_label__27pw9').textContent.trim() }));
        });

        const rates = {};

        for (const destination of destinationCountries) {
            console.log(`Scraping rate for Burkina Faso to ${destination.text}...`);

            await page.click(`#${destination.value}`);

            await page.waitForSelector('div[style="display: flex; color: rgb(241, 187, 16);"] p:nth-child(3)');

            await delay(2000);

           const rateText = await page.evaluate(() => {
                const rateElement = document.querySelector('div[style="display: flex; color: rgb(241, 187, 16);"] p:nth-child(3)');
                return rateElement ? rateElement.textContent : null;
            });

            console.log('Rate text:', rateText);

            if (!rateText) {
                console.error(`Rate element not found for Burkina Faso to ${destination.text}`);
                continue;
            }

            const rateMatch = rateText.match(/(\d+(\.\d+)?)\s*([A-Z]{3})/i);
            console.log('Rate match:', rateMatch);
            const rate = rateMatch ? rateMatch[1] : null;
            const currency = rateMatch ? rateMatch[3] : null;
            console.log('Extracted rate:', rate);
            console.log('Extracted currency:', currency);

            if (rate) {
                rates[`Burkina Faso_to_${destination.text}`] = `${rate} ${currency}`;
            }

            await page.click('#rfs-btn');
        }

        await browser.close();
        return rates;
    } catch (error) {
        console.error('Error scraping GandyamPay:', error);
        return {};
    }
}

async function main() {
    console.log('Starting main function...');
    try {
        const rates = {};
        const tapTapSendRates = await scrapeTapTapSend();
        const gandyamPayRates = await scrapeGandyamPay();
        const transfertChapChapRates = await scrapeTransfertChapChap();

        rates.tapTapSend = tapTapSendRates;
        rates.gandyamPay = gandyamPayRates;
        rates.transfertChapChap = transfertChapChapRates;

        const client = new Client({
            user: 'postgres',
            host: '127.0.0.1',
            database: 'gandyam',
            password: 'administer01',
            port: 5432,
        });

        await client.connect();

        const createTableQuery = `
            CREATE TABLE IF NOT EXISTS exchange_rates (
                source TEXT,
                destination TEXT,
                rate TEXT,
                PRIMARY KEY (source, destination)
            );
        `;
        await client.query(createTableQuery);

      for (const [source, destinations] of Object.entries(rates)) {
            for (const [destination, rate] of Object.entries(destinations)) {
                const query = `
                    INSERT INTO exchange_rates (source, destination, rate)
                    VALUES ($1, $2, $3)
                    ON CONFLICT (source, destination) DO UPDATE
                    SET rate = EXCLUDED.rate;
                `;
                const values = [source, destination, rate];
                await client.query(query, values);
            }
        }

        await client.end();

        console.log('Rates saved to PostgreSQL database');
    } catch (error) {
        console.error('Error in main function:', error);
    }
}

main().catch(console.error);