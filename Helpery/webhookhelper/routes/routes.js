var appRouter = function(app) {
    app.post("/", function(req, res) {
      console.log(req);
      res.send(200);  
    });
}

module.exports = appRouter;