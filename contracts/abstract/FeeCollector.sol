// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

abstract contract FeeCollector {
  address private _feeCollector;

  constructor(address feeCollector) {
    _feeCollector = feeCollector;
  }

  function _setFeeCollector(address feeCollectorAddress) internal {
    _feeCollector = feeCollectorAddress;
  }

  function getFeeCollector() public view returns (address) {
    return _feeCollector;
  }
}
