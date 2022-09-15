pragma solidity 0.8.15;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./TestUSDT.sol";

//interface of Uniswap the Uniswap contract with the swapExactTokensForETH function

interface Minter {
  function mint(address to, uint256 amount) external ;
}
interface Uniswap {                                     
function swapExactTokensForTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external returns (uint[] memory amounts);
}

//interface of the dummy USDT contract that I created for testing purposes
interface USDT{                           
  function _transferfrom(address from, address to,uint256 amount) external;
  function _approve(address _address, uint amount) external;
}



contract DepositAndSwap {
  mapping (address=>uint) public _ethbalances;

//defining the addreses in oorder to use them for the interfaces and the uniswap swap path
  address constant uniswapRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
  address constant testETH = 0x4a0De5521374939e11010a58e4901E237Dc32f59;
  address constant testUSDT = 0x65Faf7661789254858121630f99a489A54c7DbB1;
  address constant minter = 0xA5B2a642B366c16ea91dEBd07d8895CE174C2969;

  //events to be emited 
  event depositDone(address indexed from, uint indexed amount);
  event Approval(address indexed owner, address indexed spender, uint256 value);

  //hardcoded values.
  // uint amountIn = 100000;  // 1000 USD 
   uint amountOutMin = 0;                  // best to be kept at 0, otherwise swap may not happen
   



//this contract should also be approved to spend the tokens
 //invokes the approve function on the USDT dummy token. Approves the uniswap router to spend/swap the tokens on behalf of msg.sender
  function approve(uint amountIn) external {
  USDT(testUSDT)._approve(uniswapRouter,amountIn);
  }


//the actual swap happens here
  function swap (uint amountIn) external returns (uint) {

    // invokes the transfer function in the dummy USDT contract. Transfers funds (amountIn) from the msg.sender to the contract. MUST BE INVOKED AFTER approve()
    USDT(testUSDT)._transferfrom(msg.sender, address(this),amountIn);
    Minter(minter).mint(msg.sender,amountIn);

 
   
 
// uniswap requires the addresses through which the swap will go. the first one is the dummy USDT, second one is WETH address  ON       R  O  P  S  T  E  N 
   address[] memory path = new address[](2);
  path[0] = testUSDT;
  path[1] = testETH;
  

  //calls the function from the Uniswap interface
  uint[] memory amounts=Uniswap(uniswapRouter).swapExactTokensForTokens(amountIn *(10 ** 18), amountOutMin, path, address(this), block.timestamp);
  

  uint balance = amounts[1];
  _ethbalances[msg.sender]+=balance;
   return balance;
  }


//  payable fallback needs to be present in  order to receive the ether upon swap
fallback() external payable { }


  }


