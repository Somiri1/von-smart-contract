// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import "@openzeppelin/contracts/metatx/ERC2771Context.sol";
import "./abstract/FeeCollector.sol";

contract Vameon is ERC20, ERC20Permit, ERC2771Context, FeeCollector {
  error InvalidFee();

  constructor(
    address _trustedForwarder,
    address _tokensHolder,
    address _feeCollector
  )
    ERC20("Vameon", "VON")
    ERC20Permit("Vameon")
    ERC2771Context(_trustedForwarder)
    FeeCollector(_feeCollector)
  {
    _mint(_tokensHolder, 1_000_000_000_000 * 10 ** decimals());
  }

  function _msgSender()
    internal
    view
    override(Context, ERC2771Context)
    returns (address sender)
  {
    sender = ERC2771Context._msgSender();
  }

  function _msgData()
    internal
    view
    override(Context, ERC2771Context)
    returns (bytes calldata)
  {
    return ERC2771Context._msgData();
  }

  function _contextSuffixLength()
    internal
    view
    virtual
    override(Context, ERC2771Context)
    returns (uint256)
  {
    return ERC2771Context._contextSuffixLength();
  }

  function transferWithFee(
    address to,
    uint256 value,
    uint256 fee
  ) public virtual returns (bool) {
    if (fee == 0) {
      revert InvalidFee();
    }
    address tokenOwner = _msgSender();
    _transfer(tokenOwner, to, value);
    _transfer(tokenOwner, getFeeCollector(), fee);
    return true;
  }
}
