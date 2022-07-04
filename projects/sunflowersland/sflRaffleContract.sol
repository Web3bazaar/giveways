// File: bazar/ERC721.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract SimpleAccessControl {

    address internal _owner;

    modifier isOwner() {
        require(msg.sender == _owner, "ERR_NOT_OWNER");
        _;
    }
 
    constructor() {
        _owner = msg.sender; 
    }

    function transferOwnership(address payable newOwner) public isOwner {
        require(newOwner != address(0), "ERR_ZERO_ADDR");
        require(newOwner != _owner, "ERR_IS_OWNER");
        _owner =   newOwner;
    }
}

contract SFLRaffleTicket is ERC721, SimpleAccessControl {

    
    uint256 private _id;
    // Base URI
    string private _baseURIextended;
    string private _contractURI;
   
    constructor() ERC721("SLF Raffle Ticket", "SLF Raffle Ticket - Testnet") public 
    {  
        _id = 1 ;
        _contractURI = "https://raw.githubusercontent.com/Web3bazaar/giveways/main/projects/sunflowersland/contract";
        _baseURIextended = "https://raw.githubusercontent.com/Web3bazaar/giveways/main/projects/sunflowersland/data/";
        mint();
    }

    function mint() public returns (bool)
    {
        _mint(msg.sender, _id++);
        return true;
    }

    // set new base uri
    function setBaseURI(string memory baseURI_) external isOwner() {
        _baseURIextended = baseURI_;
    }
    
    // override original method 
    function _baseURI() internal view virtual override returns (string memory) {
        return _baseURIextended;
    }

    function setContractURI(string memory newuri)  public  isOwner() returns (bool)
    {
        _contractURI = newuri;
        return true;
    }


    function contractURI() public view returns (string memory) {
        return _contractURI;
    }
    
    


}