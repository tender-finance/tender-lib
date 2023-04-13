// SPDX-License-Identifier: BSD-3-Clause
pragma solidity >=0.8.0;
import {IWETH, IERC20, ICToken} from 'tender/interfaces/Tokens.sol';
import {SafeMath} from 'openzeppelin-contracts/contracts/utils/math/SafeMath.sol';
import {Addresses, IGlpManager, IGmxVault, IRewardRouterV2} from '../helpers/Addresses.sol';
import {IComptroller, Market} from 'tender/interfaces/Comptroller.sol';
import {ITenderPriceOracle} from 'tender/interfaces/TenderPriceOracle.sol';

contract CTokenHelper is Addresses {
  using SafeMath for uint;

  function getUnderlying(ICToken cToken) public view returns (IERC20) {
    return (cToken == tETH) ? wETH : ICToken(cToken).underlying();
  }

  function getCollateralFactor(ICToken cToken, bool vip) public view returns (uint) {
    Market memory market = unitroller.markets(address(cToken));
    return vip ? market.collateralFactorMantissaVip : market.collateralFactorMantissa;
  }

  function getLiquidationThreshold(ICToken cToken, bool vip) public view returns (uint) {
    Market memory market = unitroller.markets(address(cToken));
    return vip ? market.liquidationThresholdMantissaVip : market.liquidationThresholdMantissa;
  }

  function getUnderlyingPrice(ICToken cToken) public view returns (uint256) {
    ITenderPriceOracle oracle = unitroller.oracle();
    return oracle.getUnderlyingPrice(ICToken(cToken));
  }

  function getLeverageMultiplier(uint collateralFactor) public pure returns (uint) {
    uint totalValueThreshold = 1e18;
    uint maxValue = 100;
    uint totalValueDividend = totalValueThreshold.sub(collateralFactor).div(1e16);
    return maxValue.div(totalValueDividend);
  }
}
