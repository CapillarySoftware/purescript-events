module.exports = function(config) {
  config.set({
    frameworks : ['mocha'],
    browsers   : ['PhantomJS'],
    autoWatch  : false,
    singleRun  : true,
    plugins    : [
      'karma-mocha',
      'karma-phantomjs-launcher'
    ]
  });
};