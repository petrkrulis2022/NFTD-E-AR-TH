pragma solidity 0.8.15;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./TestUSDT.sol";

//interface of Uniswap the Uniswap contract with the swapExactTokensForETH function
interface Uniswap {                                     
function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external returns (uint[] memory amounts);
}

//interface of the dummy USDT contract that I created for testing purposes
interface USDT{                           
  function _transferfrom(address from, address to,uint256 amount) external;
  function _approve(address _address, uint amount) external;
}



contract DepositAndSwap {

//defining the addreses in oorder to use them for the interfaces and the uniswap swap path
  address constant uniswapRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
  address constant WETH = 0xc778417E063141139Fce010982780140Aa0cD5Ab;
  address constant testUSDT = 0xa4bbAEEa1009917982a1Ef7004AC69F7a635053A;

  //events to be emited 
  event depositDone(address indexed from, uint indexed amount);
  event Approval(address indexed owner, address indexed spender, uint256 value);

  //hardcoded values.
   uint amountIn = 100000000000000000000;  // 1000 USD 
   uint amountOutMin = 0;                  // best to be kept at 0, otherwise swap may not happen
   


// invokes the transfer function in the dummy USDT contract. Transfers funds (amountIn) from the msg.sender to the contract. MUST BE INVOKED AFTER approve()
  function transfer () external {
    USDT(testUSDT)._transferfrom(msg.sender, address(this),amountIn);
  }
 
//this contract should also be approved to spend the tokens
 //invokes the approve function on the USDT dummy token. Approves the uniswap router to spend/swap the tokens on behalf of msg.sender
  function approve() external {
  USDT(testUSDT)._approve(uniswapRouter,amountIn);
  }


//the actual swap happens here
  function swap () external {
   
 
// uniswap requires the addresses through which the swap will go. the first one is the dummy USDT, second one is WETH address  ON       R  O  P  S  T  E  N 
   address[] memory path = new address[](2);
  path[0] = 0xa4bbAEEa1009917982a1Ef7004AC69F7a635053A;
  path[1] = WETH;
  

  //calls the function from the Uniswap interface
  Uniswap(uniswapRouter).swapExactTokensForETH(amountIn, amountOutMin, path, address(this), block.timestamp);   
  }


//  payable fallback needs to be present in  order to receive the ether upon swap
fallback() external payable { }


  }



