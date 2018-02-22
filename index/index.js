"use strict";

import "../src/mdbootstrap/css/bootstrap.min.css";
require("./index.html");
import "../src/mdbootstrap/sass/mdb.scss";

var Elm = require("./../src/Main.elm");
var mountNode = document.getElementById("main");

var app = Elm.Main.embed(mountNode);
