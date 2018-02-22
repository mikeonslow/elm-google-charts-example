const fakeData = require("./fake_data.js");
const port = 3001;
const jsonServer = require("json-server");
const fs = require("fs");
const server = jsonServer.create();
const data = fakeData();

fs.writeFileSync("./db.json", JSON.stringify(data));

const middlewares = jsonServer.defaults();
const router = jsonServer.router("./db.json");

fs.readFile("./db.json", (err, data) => {
  if (err) throw err;
  console.log(data.toString());
  server.use(middlewares);
  server.use("/api", router);
  server.listen(port);
  console.log("Server started and listening at http://localhost:" + port + "/");
});
