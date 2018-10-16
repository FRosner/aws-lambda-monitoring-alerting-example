"use strict";

const assert = require("chai").assert;
const lambdaLocal = require("lambda-local");
const calculator = require("../src/lambda");

describe("calculator", function() {
  it("add a and b", done => {
    lambdaLocal.execute({
      event: {
        a: 3,
        b: 8
      },
      lambdaFunc: calculator,
      timeoutMs: 3000,
      region: "eu-central-1",
      callback: function(err, data) {
        assert.equal(err, null);
        assert.deepEqual(data, {result: 11});
        done();
      }
    });
  });
});
