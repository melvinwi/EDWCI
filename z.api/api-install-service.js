var Service = require('node-windows').Service;

// service name and description
var SERVICE_NAME = 'Data Transformation API Server';
var SERVICE_DESC = 'The Data Transformation API Server (NodeJS Express Web App)';



// Create a new service object
var svc = new Service({
  name: SERVICE_NAME,
  description: SERVICE_DESC,
  script: require('path').join(__dirname,'server.js'),
  wait: 5, // check if running every 5 seconds and (if required) auto-restart
  grow: 0  // don't grow the wait time
});

// Listen for the "install" event, which indicates the
// process is available as a service.
svc.on('install',function(){
  svc.start();
});

svc.install();