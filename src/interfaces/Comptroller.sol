// SPDX-License-Identifier: BSD-3-Clause
pragma solidity >=0.8.0;

import {ITenderPriceOracle} from './TenderPriceOracle.sol';
import {ICToken} from './CToken.sol';
import {IERC20} from './Tokens.sol';

struct Market {
  bool isListed;
  uint collateralFactorMantissa;
  uint liquidationThresholdMantissa;
  uint collateralFactorMantissaVip;
  uint liquidationThresholdMantissaVip;
  bool isComped;
  bool isPrivate;
  bool onlyWhitelistedBorrow;
}

interface IComptroller {
  function isComptroller () external view returns (bool);
  function oracle() external view returns (ITenderPriceOracle);

  function markets(address) external view returns (Market memory);

  function enterMarkets(ICToken[] calldata cTokens) external returns (uint[] memory);
  function exitMarket(ICToken cToken) external returns (uint);
  function addToMarketExternal(ICToken cToken, address borrower) external;
  function mintAllowed(ICToken cToken, address minter, uint mintAmount) external returns (uint);
  function mintVerify(ICToken cToken, address minter, uint mintAmount, uint mintTokens) external;
  function redeemAllowed(ICToken cToken, address redeemer, uint redeemTokens) external returns (uint);
  function redeemVerify(ICToken cToken, address redeemer, uint redeemAmount, uint redeemTokens) external;
  function borrowAllowed(ICToken cToken, address borrower, uint borrowAmount) external returns (uint);
  function borrowVerify(ICToken cToken, address borrower, uint borrowAmount) external;
  function getIsAccountVip(address account) external view returns (bool);
  function getAllMarkets() external view returns (ICToken[] memory);
  function getAccountLiquidity(address account) external view returns (uint, uint, uint);
  function getHypotheticalAccountLiquidity(address account, ICToken cTokenModify, uint redeemTokens, uint borrowAmount) external view returns (uint, uint, uint);
  function _setPriceOracle(address oracle_) external;
  function _supportMarket(address delegator, bool isComped, bool isPrivate, bool onlyWhitelistedBorrow) external;
  function _setFactorsAndThresholds(address delegator, uint collateralFactor, uint collateralVIP, uint threshold, uint thresholdVIP) external;

    /// @notice Indicator that this is a Comptroller contract (for inspection)
  function repayBorrowAllowed(
    ICToken cToken,
    address payer,
    address borrower,
    uint repayAmount
  ) external returns (uint);

  function repayBorrowVerify(
    ICToken cToken,
    address payer,
    address borrower,
    uint repayAmount,
    uint borrowerIndex
  ) external;

  function liquidateBorrowAllowed(
    ICToken cTokenBorrowed,
    ICToken cTokenCollateral,
    address liquidator,
    address borrower,
    uint repayAmount
  ) external returns (uint);
  function liquidateBorrowVerify(
    ICToken cTokenBorrowed,
    ICToken cTokenCollateral,
    address liquidator,
    address borrower,
    uint repayAmount,
    uint seizeTokens
  ) external;

  function seizeAllowed(
    ICToken cTokenCollateral,
    ICToken cTokenBorrowed,
    address liquidator,
    address borrower,
    uint seizeTokens
  ) external returns (uint);

  function seizeVerify(
    ICToken cTokenCollateral,
    ICToken cTokenBorrowed,
    address liquidator,
    address borrower,
    uint seizeTokens
  ) external;
  function transferAllowed(
    ICToken cToken,
    address src,
    address dst,
    uint transferTokens
  ) external returns (uint);

  function transferVerify(
    ICToken cToken,
    address src,
    address dst,
    uint transferTokens
  ) external;

  /*** Liquidity/Liquidation Calculations ***/
  function liquidateCalculateSeizeTokens(
    ICToken cTokenBorrowed,
    ICToken cTokenCollateral,
    uint repayAmount
  ) external view returns (uint, uint);
}
