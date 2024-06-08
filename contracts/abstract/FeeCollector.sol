// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

abstract contract FeeCollector {
  address private immutable _feeCollector;

  constructor(address feeCollector) {
    _feeCollector = feeCollector;
  }

  function getFeeCollector() public view returns (address) {
    return _feeCollector;
  }
}
