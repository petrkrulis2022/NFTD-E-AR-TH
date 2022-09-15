// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";


contract NFTDollar is ERC20, ERC20Burnable {
    address  payable public owner;

    constructor() ERC20("NFT Dollar", "NFTD") {
        owner =payable(msg.sender);
    }

        modifier onlyOwner {
        require(msg.sender==owner);
        _;
    }

    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount * (10 ** uint256(decimals())));
    }

    function transferOwnership (address payable newOwner) external onlyOwner {
        owner = newOwner;
    }

}