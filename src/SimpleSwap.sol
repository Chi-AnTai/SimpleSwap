// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;
import "./TestERC20.sol";

contract SimpleSwap {
  // phase 1
  TestERC20 public token0;
  TestERC20 public token1;

  // phase 2
  uint256 public totalSupply = 0;
  mapping(address => uint256) public share;

  constructor(address _token0, address _token1) {
    token0 = TestERC20(_token0);
    token1 = TestERC20(_token1);
  }

  function swap(address _tokenIn, uint256 _amountIn) public {
    if (_tokenIn == address(token0)) {
      token0.transferFrom(msg.sender, address(this), _amountIn);
      token1.transfer(msg.sender, _amountIn);
    } else if (_tokenIn == address(token1)) {
      token1.transferFrom(msg.sender, address(this), _amountIn);
      token0.transfer(msg.sender, _amountIn);
    }
  }

  // phase 1
  function addLiquidity1(uint256 _amount) public {
    token0.transferFrom(msg.sender, address(this), _amount);
    token1.transferFrom(msg.sender, address(this), _amount);
  }

  function removeLiquidity1() public {
    token0.transfer(msg.sender, token0.balanceOf(address(this)));
    token1.transfer(msg.sender, token1.balanceOf(address(this)));
  }

  // phase 2
  function addLiquidity2(uint256 _amount) public {
    token0.transferFrom(msg.sender, address(this), _amount);
    token1.transferFrom(msg.sender, address(this), _amount);
    totalSupply += _amount;
    share[msg.sender] += _amount;
  }

  function removeLiquidity2() public {
    uint256 removeAmount0 = share[msg.sender] * token0.balanceOf(address(this)) / totalSupply;
    uint256 removeAmount1 = share[msg.sender] * token1.balanceOf(address(this)) / totalSupply;

    token0.transfer(msg.sender, removeAmount0);
    token1.transfer(msg.sender, removeAmount1);

    totalSupply -= share[msg.sender];
    share[msg.sender] = 0;
  }
}