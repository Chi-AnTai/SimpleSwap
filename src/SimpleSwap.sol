// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;
import "./TestERC20.sol";

contract SimpleSwap {
  // phase 1
  TestERC20 public token0;
  TestERC20 public token1;

  // phase 2
  // uint256 public totalSupply = 0;
  // mapping(address => uint256) public share;

  constructor(address _token0, address _token1) {
    
  }

  function swap(address _tokenIn, uint256 _amountIn) public {
    
  }

  // phase 1
  function addLiquidity1(uint256 _amount) public {
    
  }

  function removeLiquidity1() public {
    
  }

  // phase 2
  // function addLiquidity2(uint256 _amount) public {
  // }

  // function removeLiquidity2() public {
  // }
}