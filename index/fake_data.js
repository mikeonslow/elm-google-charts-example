/*global require */

const faker = require("faker");
const R = require("ramda");

var MakeData = function() {
  var widgetCount = 1; // TODO Refactor to more functional style with something like http://ramdajs.com/docs/#addIndex, ran out of time :[

  const dashboardMax = 1;
  const widgetsPerDashboard = 9;

  const dashboards = generateDashboards(dashboardMax);

  var widgetMapper = R.compose(
    R.map(n => {
      return generateWidgets(widgetsPerDashboard, n.id);
    })
  );

  const widgets = R.flatten(widgetMapper(dashboards));

  const charts = R.map(n => {
    return generateChart(n.id);
  }, widgets);

  function generateDashboards(count) {
    const start = 1;
    return R.map(n => {
      return { id: n, label: `Dashboard ${n}` };
    }, R.range(start, start + count));
  }

  function generateWidgets(count, dashboardId) {
    return R.map(n => {
      const id = widgetCount++;
      return {
        id: id,
        dashboardId: dashboardId,
        label: `Widget ${id}`
      };
    }, R.range(0, count));
  }

  function generateChart(widgetId) {
    return { id: widgetId, points: generateFakeChartData(8) };
  }

  function generateFakeChartData(max) {
    return R.map(n => {
      return [faker.name.findName(), faker.random.number({ min: 5, max: 50 })];
    }, R.range(1, max));
  }

  return {
    dashboards: dashboards,
    widgets: widgets,
    charts: charts
  };
};

module.exports = MakeData;
