/*
 * Container Image MongoDB
 */

"use strict";

console.log("using admin database");
admin = db.getSiblingDB("admin");

console.log("creating admin user");
admin.createUser({
	user: "admin",
	pwd: passwordPrompt(),
	roles: ["root"]
});

console.log("disabling telemetry");
disableTelemetry();
