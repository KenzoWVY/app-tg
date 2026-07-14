const PORT = 3000;

import app from './app.js';

const startServer = async () => {
    app.listen(PORT, () => {
        console.log('Server running.');
    });
};

startServer();