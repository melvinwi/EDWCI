var moment = require('moment');

var DATE_FORMAT = 'YYYY-MM-DD HH:mm:ss' 


info = function (context, input) {
  console.log(moment().format(DATE_FORMAT)+' INFO |'+context+'| '+input);
};


error = function (context, input) {
  console.log(moment().format(DATE_FORMAT)+' ERROR|'+context+'| '+input);
};

warn = function (context, input) {
  console.log(moment().format(DATE_FORMAT)+' WARN |'+context+'| '+input);
};

debug = function (context, input, debugFlag) {
  if (debugFlag == true)
    console.log(moment().format(DATE_FORMAT)+' DEBUG|'+context+'| '+input);
};

OK = function (context, input) {
  console.log(moment().format(DATE_FORMAT)+' OK   |'+context+'| '+input);
};


module.exports = {
  info: function(context, input) {
    info(context, input);
  },

  error: function(context, input) {
    error(context, input);
  },

  warn: function(context, input) {
    warn(context, input);
  },
  debug: function(context, input, debugFlag) {
    debug(context, input, debugFlag);
  },
  OK: function(context, input) {
    OK(context, input);
  }
};
