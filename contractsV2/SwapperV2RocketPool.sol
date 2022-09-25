
pragma solidity 0.8.7;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./TestUSDT.sol";

//Goerli
/// the contract still needs to have the burn method of the Reth contract invoked ( at address 0x178e141a0e3b34152f73ff610437a7bf9b83267a ) so that it is able to unstake the reth and convert it back to eth
// also need another mapping to store the amount of reth received from every swap of every msg.sender ( sincre reth/eth ration is not 1:1
//this contract should also be approved to spend the tokens. It mmust be approved manually by the msg.sender by invoking the approve function in the USDT contract and using this contract's address as input


//=======================================================================================================================================-
//interfaces
//========================================================================================================================================
interface Minter {
  function mint(address to, uint256 amount) external ;
}
interface Uniswap {                                     
function swapExactTokensForTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external returns (uint[] memory amounts);
}

interface USDT{                           
  function _transferfrom(address from, address to,uint256 amount) external;
  function _approve(address _address, uint amount) external;
}

interface Rocketpool {
  function deposit()  external payable;
}

interface Iweth {
  function withdraw(uint wad) external;
}

interface INFTLandToken {
  function mint(address _address) external payable returns (uint256);
}





contract DepositAndSwap {
  mapping (address=>uint) public _ethbalances;

//========================================================================================================================================
//defining the addreses in order to use them for the interfaces and the uniswap swap path
//========================================================================================================================================
  address constant uniswapRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
  address constant RocketpoolAddress = 0x2cac916b2A963Bf162f076C0a8a4a8200BCFBfb4;
  address constant testETH = 0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6;        //weth contract on Goerli
  address constant testUSDT = 0xe00D656db10587363c6106D003d08fBE2F0EaC81;
  address constant minter = 0xa362c101a5d1317Ac30376eeEEFb543833d34d1A;
  address constant NFTLandAddress  = 0x9a565Ac0E639A2D207925Be58BaBf5703370891b ;

  //events 
  event depositDone(address indexed from, uint indexed amount);
  event Approval(address indexed owner, address indexed spender, uint256 value);

  //hardcoded values.
   uint amountOutMin = 0;                  // best to be kept at 0, otherwise swap may not happen
   

//========================================================================================================================================
// 1. approving the router 
// 2. transfer USDT to this contract
// 3. Mints the native NFTD token at 1 to 1 ratio 
// 4. Swaps USDT for weth
// 5. unrwaps the weth for eth
// 6. deposits the eth and gets Reth back
// 7. Mints NFTLand plot
//========================================================================================================================================
  function swap (uint amountIn) external  returns (uint) {
    USDT(testUSDT)._approve(uniswapRouter,amountIn);                // approves the router to spend the USDT on behalf of the msg.sender
    USDT(testUSDT)._transferfrom(msg.sender, address(this),amountIn);// transfers USDT to this contract
    Minter(minter).mint(msg.sender,amountIn);                       //mints the native NFTD token
    INFTLandToken(NFTLandAddress).mint(msg.sender);                 // Mints the NFTLand plot

  //an array of addresses required for the router to implement the swap
   address[] memory path = new address[](2);
  path[0] = testUSDT;
  path[1] = testETH;
  

  //calls the function from the Uniswap interface
 uint[] memory balances = Uniswap(uniswapRouter).swapExactTokensForTokens(amountIn * 10 ** 18, amountOutMin, path, address(this), block.timestamp);
 uint amount = balances[1];       // the amount of weth received upon swap                                          
_ethbalances[msg.sender]+=amount;
Iweth(testETH).withdraw(_ethbalances[msg.sender]);//unwraps the eth as RocketPool accepts only plain eth
Rocketpool(RocketpoolAddress).deposit{value:_ethbalances[msg.sender]}(); //deposits to rocketpool
emit depositDone(msg.sender, amount);
  
 return amount;
  
  }

//========================================================================================================================================
//  payable fallback needs to be present in  order to receive the ether upon swap
//========================================================================================================================================
fallback() external payable { }

 receive() external payable {}
  }







