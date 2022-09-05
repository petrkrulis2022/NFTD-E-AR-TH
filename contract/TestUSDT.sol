pragma solidity ^0.8.15;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TestUSDT is ERC20 {


constructor ()  ERC20 ("TestUSDT","TUSDT") {
    _mint(msg.sender,1000*(10 ** uint256(decimals())));
 }

function mint(address account, uint256 amount) external  {
      ERC20._mint(account, amount *(10 ** uint256(decimals())));
       
}


function _transferfrom(address from,
        address to,
        uint256 amount) external {

            ERC20.transferFrom(from,to,amount*(10 ** uint256(decimals())));
        }

        function getBalance (address _address) external  view returns(uint){
    return ERC20.balanceOf(_address)*(10 ** uint256(decimals()));
}

function _approve(address _address, uint amount) external {
    ERC20.approve(_address, amount*(10 ** uint256(decimals())));
}
}

