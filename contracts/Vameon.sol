// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./abstract/ERC2771ContextStorage.sol";
import "./abstract/FeeCollector.sol";

contract Vameon is
  ERC20,
  ERC20Permit,
  ERC2771ContextStorage,
  Ownable,
  FeeCollector
{
  error InvalidFee();

  constructor(
    address _trustedForwarder,
    address vesting,
    address liquidity,
    address marketing,
    address devAndSupport,
    address treasury,
    address staking
  )
    ERC20("Vameon", "VON")
    ERC20Permit("Vameon")
    Ownable(msg.sender)
    ERC2771ContextStorage(_trustedForwarder)
    FeeCollector(msg.sender)
  {
    _mint(vesting, 340_000_000_000 * 10 ** decimals());
    _mint(liquidity, 40_000_000_000 * 10 ** decimals());
    _mint(marketing, 240_000_000_000 * 10 ** decimals());
    _mint(devAndSupport, 100_000_000_000 * 10 ** decimals());
    _mint(treasury, 150_000_000_000 * 10 ** decimals());
    _mint(staking, 130_000_000_000 * 10 ** decimals());
  }

  function setTrustedForwarder(address _trustedForwarder) public onlyOwner {
    _setTrustedForwarder(_trustedForwarder);
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

  function setFeeCollector(address feeCollectorAddress) public onlyOwner {
    _setFeeCollector(feeCollectorAddress);
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
