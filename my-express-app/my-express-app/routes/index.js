const express = require('express');
const router = express.Router();

router.get('/', (req, res) => {
  res.send('Base Route tukar ni sikit');
});

module.exports = router;