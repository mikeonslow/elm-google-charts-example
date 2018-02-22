/*global require */

const faker = require("faker");
const R = require("ramda");

var MakeData = function() {
  return {
    api: {
      dashboards: generateDashboards(),
      widgets: []
    }
  };
};

function generateDashboards(count) {
  const start = 100001;
  return R.map(n => {
    return { id: n };
  }, R.range(start, start + count));
}

module.exports = MakeData;
