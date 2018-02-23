"use strict";

import "../src/css/mdbootstrap/css/bootstrap.min.css";
// require("./index.html");
import "../src/css/mdbootstrap/sass/mdb.scss";

const faker = require("faker");
const R = require("ramda");

(function() {
  var startup = function() {
    var chartsLoaded = false;

    google.charts.load("current", { packages: ["corechart"] });
    google.charts.setOnLoadCallback(function() {
      chartsLoaded = true;
    });

    function getRandomInt(min, max) {
      min = Math.ceil(min);
      max = Math.floor(max);
      return Math.floor(Math.random() * (max - min)) + min; //The maximum is exclusive and the minimum is inclusive
    }

    function drawChart(id) {
      // TODO move all of this logic into it's own module once PoC is completed
      const options = {
        legend: "right",
        tooltip: { trigger: "selection" }
      };
      var chartElemInterval = setInterval(function() {
        if (chartsLoaded === true && document.getElementById(id) !== null) {
          clearInterval(chartElemInterval);
          var data = new google.visualization.DataTable();
          data.addColumn("string", "Topping");
          data.addColumn("number", "Slices");
          data.addRows(generateFakeChartData(getRandomInt(4, 9)));
          var chart = new google.visualization.PieChart(
            document.getElementById(id)
          );
          chart.draw(data, options);
          console.log("chart (" + id + ") loaded...");
        }
      }, 20);
    }

    function generateFakeChartData(max) {
      return R.map(n => {
        return [faker.name.findName(), getRandomInt(5, 10)];
      }, R.range(1, max));
    }

    var Elm = require("../src/elm/Main.elm");
    var mountNode = document.getElementById("main");

    var app = Elm.Main.embed(mountNode);

    app.ports.receiveChartData.subscribe(function(data) {
      console.log("receiveChartData " + data);
      // drawChart();
    });
  };

  window.addEventListener("load", startup, false);
})();
