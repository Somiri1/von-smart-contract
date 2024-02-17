// SPDX-License-Identifier: MIT
pragma solidity >=0.8.20;

import "@openzeppelin/contracts/metatx/ERC2771Context.sol";

abstract contract ERC2771ContextStorage is ERC2771Context(address(0)) {
  address private _trustedForwarderStorage;

  constructor(address _trustedForwarder) {
    _setTrustedForwarder(_trustedForwarder);
  }

  function trustedForwarder() public view virtual override returns (address) {
    return _trustedForwarderStorage;
  }

  function _setTrustedForwarder(address _forwarder) internal {
    _trustedForwarderStorage = _forwarder;
  }
}
