const express = require("express");

const app = express();
const PORT = 3000;

app.get("/", (req, res) => {
  res.send(`
    <h1>Hello World from Docker Multi-Stage Build!</h1>
    <p><strong>Name:</strong> Tanmay Mittal</p>
    <p><strong>Roll No:</strong> 24BCS10491</p>
  `);
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});