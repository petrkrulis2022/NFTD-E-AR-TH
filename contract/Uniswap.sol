pragma solidity 0.8.15;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./TestUSDT.sol";

interface Uniswap {                                     //interface of Uniswap
function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external returns (uint[] memory amounts);
}

interface USDT{
  function _transferfrom(address from, address to,uint256 amount) external;
  function _approve(address _address, uint amount) external;
}

contract DepositAndSwap {



  address constant uniswapRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
  address constant WETH = 0xc778417E063141139Fce010982780140Aa0cD5Ab;
  address constant testUSDT = 0xa4bbAEEa1009917982a1Ef7004AC69F7a635053A;

  event depositDone(address indexed from, uint indexed amount);
  event Approval(address indexed owner, address indexed spender, uint256 value);
   uint amountIn = 100000000000000000000;  
   uint amountOutMin = 0;
   

  function transfer () external {
    USDT(testUSDT)._transferfrom(msg.sender, address(this),amountIn);
  }
 
  function approve() external {
  USDT(testUSDT)._approve(uniswapRouter,amountIn);
  }

  function swap () external {
   
 

   address[] memory path = new address[](2);
  path[0] = 0xa4bbAEEa1009917982a1Ef7004AC69F7a635053A;
  path[1] = WETH;
  
  Uniswap(uniswapRouter).swapExactTokensForETH(amountIn, amountOutMin, path, address(this), block.timestamp);
  }

fallback() external payable { }


  }



