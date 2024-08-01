// Subfolder3 route file
const express = require('express');
const router = express.Router();

router.get('/', (req, res) => {
  res.send('Subfolder3 Route');
});

router.delete('/', (req, res) => {
  res.send('Subfolder3 Route');
});

module.exports = router;