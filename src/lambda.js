"use strict";

const add = require("sum-of-two-numbers");

exports.handler = (event, context, callback) => {
  try {
    setTimeout(function() {}, event.timeout);
    if (event.error) {
      throw Error("error!");
    }
    const result = {
      result: add(event.a, event.b)
    };
    callback(null, result);
  } catch (err) {
    callback(err);
  }
};
