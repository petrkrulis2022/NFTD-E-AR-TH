//SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.7;
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";


contract NFTLand is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter tokenIds; 
   


    constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol) { }

    function mint(address _address) public payable returns (uint256) {
        uint256 newItemId = tokenIds.current();
        _mint(_address, newItemId);
        _setTokenURI(
            newItemId,
            "https://ipfs.io/ipfs/QmRiunVjjk3dfr8dzTHVN5m5iJbA411cGRtXtSZxT3vPQM"
        );
        tokenIds.increment(); /// tokenId should be the next Id from the counter
        return newItemId;
        //erc721 mint
    }

}
