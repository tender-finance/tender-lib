// SPDX-License-Identifier: BSD-3-Clause
pragma solidity 0.8.10;

import "./CErc20.sol";
import "./CTokenInterfaces.sol";

/**
  * @title Compound's CErc20Delegate Contract
* @notice CTokens which wrap an EIP-20 underlying and are delegated to
* @author Compound
*/
contract CErc20Delegate is CErc20, CDelegateInterface {
  /**
    * @notice Construct an empty delegate
  */

  function initialize (
    address underlying_,
    IComptroller comptroller_,
    InterestRateModel interestRateModel_,
    uint initialExchangeRateMantissa_,
    string memory name_,
    string memory symbol_,
    uint8 decimals_,
    bool isGLP_
  ) public override {
    // CToken initialize does the bulk of the work
    super.initialize(
      comptroller_,
      interestRateModel_,
      initialExchangeRateMantissa_,
      name_,
      symbol_,
      decimals_,
      isGLP_
    );
    // Set underlying and sanity check it
    underlying = underlying_;
    IERC20(underlying).totalSupply();
  }
  function _becomeImplementation(bytes memory data) virtual override public {
    // Shh -- currently unused
    data;

    // Shh -- we don't ever want this hook to be marked pure
    if (false) {
      implementation = address(0);
    }

    require(msg.sender == admin, "only the admin may call _becomeImplementation");
  }

  /**
    * @notice Called by the delegator on a delegate to forfeit its responsibility
  */
  function _resignImplementation() virtual override public {
    // Shh -- we don't ever want this hook to be marked pure
    if (false) {
      implementation = address(0);
    }

    require(msg.sender == admin, "only the admin may call _resignImplementation");
  }
}
