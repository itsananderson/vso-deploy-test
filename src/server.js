var express = require('express');
var app = express();

app.get("/", function(req, res) {
  res.send("Hello, World! 7");
});

app.listen(process.env.PORT || 3000, function() {
  console.log("listening");
});
