// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;
import "../src/TestERC20.sol";
import "../src/SimpleSwap.sol";
import { Test } from "forge-std/Test.sol";

contract SimpleSwapTest is Test {
  address public user = makeAddr("user");
  address public lp1 = makeAddr("lp1");
  address public lp2 = makeAddr("lp2");
  TestERC20 public token0;
  TestERC20 public token1;
  SimpleSwap public simpleSwap;

  function setUp() public {
    token0 = new TestERC20("token 0", "TK0");
    token1 = new TestERC20("token 1", "TK1");

    token0.mint(user, 100e18);
    token0.mint(lp1, 100e18);
    token0.mint(lp2, 100e18);
    
    token1.mint(user, 100e18);
    token1.mint(lp1, 100e18);
    token1.mint(lp2, 100e18);

    simpleSwap = new SimpleSwap(address(token0), address(token1));

    vm.startPrank(user);
    token0.approve(address(simpleSwap), 100e18);
    token1.approve(address(simpleSwap), 100e18);
    vm.stopPrank();

    vm.startPrank(lp1);
    token0.approve(address(simpleSwap), 100e18);
    token1.approve(address(simpleSwap), 100e18);
    vm.stopPrank();

    vm.startPrank(lp2);
    token0.approve(address(simpleSwap), 100e18);
    token1.approve(address(simpleSwap), 100e18);
    vm.stopPrank();
  }

  function testAddLiquidity1() public {
    vm.startPrank(lp1);
    simpleSwap.addLiquidity1(10e18);

    assertEq(token0.balanceOf(lp1), 90e18);
    assertEq(token1.balanceOf(lp1), 90e18);

    assertEq(token0.balanceOf(address(simpleSwap)), 10e18);
    assertEq(token1.balanceOf(address(simpleSwap)), 10e18);
    vm.stopPrank();
  }

  function testSwap() public {
    testAddLiquidity1();

    vm.startPrank(user);
    simpleSwap.swap(address(token0), 5e18);

    assertEq(token0.balanceOf(user), 95e18);
    assertEq(token1.balanceOf(user), 105e18);

    assertEq(token0.balanceOf(address(simpleSwap)), 15e18);
    assertEq(token1.balanceOf(address(simpleSwap)), 5e18);
    vm.stopPrank();
  }

  function testRemoveLiquidity1() public {
    testSwap();

    vm.startPrank(lp1);
    simpleSwap.removeLiquidity1();

    assertEq(token0.balanceOf(lp1), 105e18);
    assertEq(token1.balanceOf(lp1), 95e18);

    assertEq(token0.balanceOf(address(simpleSwap)), 0);
    assertEq(token1.balanceOf(address(simpleSwap)), 0);
    vm.stopPrank();
  }

  // phase 2
  function testAddLiquidity2() public {
    // lp1
    vm.startPrank(lp1);
    simpleSwap.addLiquidity2(10e18);

    assertEq(token0.balanceOf(lp1), 90e18);
    assertEq(token1.balanceOf(lp1), 90e18);

    assertEq(token0.balanceOf(address(simpleSwap)), 10e18);
    assertEq(token1.balanceOf(address(simpleSwap)), 10e18);
    vm.stopPrank();

    // lp2
    vm.startPrank(lp2);
    simpleSwap.addLiquidity2(5e18);

    assertEq(token0.balanceOf(lp2), 95e18);
    assertEq(token1.balanceOf(lp2), 95e18);

    assertEq(token0.balanceOf(address(simpleSwap)), 15e18);
    assertEq(token1.balanceOf(address(simpleSwap)), 15e18);
    vm.stopPrank();
  }

  function testSwap2() public {
    testAddLiquidity2();

    vm.startPrank(user);
    simpleSwap.swap(address(token0), 3e18);

    assertEq(token0.balanceOf(user), 97e18);
    assertEq(token1.balanceOf(user), 103e18);

    assertEq(token0.balanceOf(address(simpleSwap)), 18e18);
    assertEq(token1.balanceOf(address(simpleSwap)), 12e18);
    vm.stopPrank();
  }

  function testRemoveLiquidity2() public {
    testSwap2();
    // lp1
    vm.startPrank(lp1);
    simpleSwap.removeLiquidity2();

    assertEq(token0.balanceOf(lp1), 102e18);
    assertEq(token1.balanceOf(lp1), 98e18);
    vm.stopPrank();

    // lp2
    vm.startPrank(lp2);
    simpleSwap.removeLiquidity1();

    assertEq(token0.balanceOf(lp2), 101e18);
    assertEq(token1.balanceOf(lp2), 99e18);
    vm.stopPrank();

    assertEq(token0.balanceOf(address(simpleSwap)), 0);
    assertEq(token1.balanceOf(address(simpleSwap)), 0);
  }
}