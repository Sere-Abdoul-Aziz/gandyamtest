require('dotenv').config();
const express = require('express');
const bodyParser = require('body-parser');
const routes = require('./routes');
const { errorHandler } = require('./middlewares');

const app = express();
const PORT = 3000;

app.use(bodyParser.json());
app.use(routes);


app.use(errorHandler);

app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});