// Subfolder1 route file
const express = require('express');
const router = express.Router();

router.get('/', (req, res) => {
  res.send('Subfolder1 Route');
});

module.exports = router;