// SPDX-License-Identifier: BSD-3-Clause
pragma solidity >=0.8.0;
import {IERC20} from 'oz/token/ERC20/ERC20.sol';
import {IERC721} from 'oz/token/ERC721/ERC721.sol';
import {IERC165} from 'oz/token/ERC721/ERC721.sol';
import {ICToken} from './CToken.sol';

interface IWETH is IERC20 {
  function deposit() external payable;
  function withdraw(uint256) external;
}

interface IERC721Receiver {
  function onERC721Received(
    address operator,
    address from,
    uint256 tokenId,
    bytes calldata data
  ) external returns (bytes4);
}
