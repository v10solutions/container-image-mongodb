/*
 * Container Image MongoDB
 */

"use strict";

console.log("using wms database");
wms = db.getSiblingDB("wms");

console.log("creating wms user");
wms.createUser({
	user: "wms",
	pwd: passwordPrompt(),
	roles: ["dbOwner"]
});
