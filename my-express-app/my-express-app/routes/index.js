// Base route file
const express = require('express');
const app = express();
const port = 3000;

// Import routes
const baseRoutes = require('./routes/index');
const subfolder1Routes = require('./subfolder1/routes/route1');
const subfolder3Routes = require('./subfolder2/subfolder3/routes/route2');

// Use routes
app.use('/base', baseRoutes);
app.use('/sub1', subfolder1Routes);
app.use('/sub3', subfolder3Routes);

app.get('/', (req, res) => {
  res.send('Hello World!');
});

app.listen(port, () => {
  console.log(`Example app listening at http://localhost:${port}`);
});