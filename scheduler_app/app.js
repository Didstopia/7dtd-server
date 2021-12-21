#!/usr/bin/env node

var debug = false;

var child_process = require('child_process');

var startupDelayInSeconds = 60 * 5;
var runIntervalInSeconds = 60 * 5;

if (debug)
{
	startupDelayInSeconds = 1;
	runIntervalInSeconds = 60;
}

// Start the endless loop after a delay (allow the server to start)
setTimeout(function()
{
	checkForUpdates();
}, 1000 * startupDelayInSeconds);

function checkForUpdates()
{
	setInterval(function()
	{
		if (debug) console.log("Scheduled update triggered");
		child_process.exec('bash /app/update_check.sh', { timeout: 60 * 1000, env: process.env }, function (err, stdout, stderr) {
			if (debug) console.log(stdout);
		})
	}, 1000 * runIntervalInSeconds);
}
