// Subfolder3 route file
const express = require('express');
const router = express.Router();

router.get('/', (req, res) => {
  res.send('Subfolder3 Route');
  res.send('Subfolder4 Route');
});

module.exports = router;