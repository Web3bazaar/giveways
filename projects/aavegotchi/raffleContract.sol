// SPDX-License-Identifier: MIT
pragma solidity 0.8.14;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "../webazaar/BatchBazaarProd.sol";
import "@openzeppelin/contracts/utils/Context.sol";


contract BazaarRaffleTicket is Context, ERC721, MultiAccessControl, ERC721Holder  {

    uint256 public _id;
    // Base URI
    string private _baseURIextended;
    string private _contractURI;
    uint256 public MAX_SUPPLY;
    // address
    address  public  _projectTokenAddress;
    address  public  _bazaarContract;

    // raffles types
    uint8 private BRONZE = 1;
    uint8 private SILVER = 8;
    uint8 private GOLD   = 20;

    // rafles prices
    uint256 public BRONZE_PRICE = 1000000000000000000;
    uint256 public SILVER_PRICE = 5000000000000000000;
    uint256 public GOLD_PRICE   = 10000000000000000000;

    constructor() ERC721("Web3Bazaar Raffle Ticket", "Web3Bazaar Raffle Ticket") public 
    {
        _id = 1 ;
        _contractURI = "https://raw.githubusercontent.com/Web3bazaar/giveways/main/projects/sunflowersland/contract";
        _baseURIextended = "https://raw.githubusercontent.com/Web3bazaar/giveways/main/projects/sunflowersland/data/";
         MAX_SUPPLY = 100000;
        _projectTokenAddress   = 0x89A84dc58ABA7909818C471B2EbFBc94e6C96c41;
        _bazaarContract = 0x0A50B369f107aeF88E83B79F8E437EB623ac4a0a;
         //_bazaarContract = s;
    }
 
    function mint(uint8 raffleType, uint8 quantity) public  returns (uint256)
    {
         require(raffleType ==  BRONZE ||
                    raffleType ==  SILVER || 
                        raffleType ==  GOLD , 'WEB3BAZAAR_RAFFLE_ERR: RAFFLE TYPE ISNT VALID');
        require(quantity > 0 &&  quantity < 1000, 'WEB3BAZAAR_RAFFLE_ERR: QUANTITY_RANGE_0_TO_1000');
        
         uint256 unityPrice = 0;
         uint256 totalTickets = raffleType * quantity;

         if(raffleType == BRONZE){
             unityPrice = BRONZE_PRICE;
         }else if(raffleType == SILVER){
              unityPrice = SILVER_PRICE ;
         }else if(raffleType == GOLD){
            unityPrice = GOLD_PRICE ; 
         }
         require(unityPrice > 0 ,  'WEB3BAZAAR_RAFFLE_ERR: UNITY_PRICE_ISNT_GREATER_THEN_ZERO');
    
         uint256 totalAmount = unityPrice * quantity;

         address[]  memory creatorTokenAddress  = new address[](totalTickets);
         uint256[]  memory creatorTokenId = new uint256[](totalTickets);
         uint256[]  memory creatorTokenAmount  = new uint256[](totalTickets);
         uint8[]    memory creatorTokenType  = new uint8[](totalTickets);

         //check the allownces for project token
        // require(totalAmount <= IERC20(_projectTokenAddress).allowance(msg.sender, address(this) ), 'WEB3BAZAAR_RAFLLES_ERR: ALLOWANCE_ISNT_ENOUGH');
        require(totalAmount <= IERC20(_projectTokenAddress).balanceOf(msg.sender), 'WEB3BAZAAR_RAFFLE_ERR: ERR_NOT_ENOUGH_FUNDS_ERC20');

        // mint ticket store on array to create trade after
        for (uint i = 0; i < totalTickets; i++) 
        {
             uint256 id =  _id++;
            _mint(address(this), id );
            //fill array for trade
            creatorTokenAddress[i] = address(this);
            creatorTokenId[i] = id;
            creatorTokenAmount[i] = 1;
            creatorTokenType[i] = 3;
        }

        //  creator token addr
        address[]  memory executerTokenAddress = new address[](1);
        executerTokenAddress[0] = _projectTokenAddress;
        // creatorTokenId 
        uint256[]  memory executerTokenId = new uint256[](1);
        executerTokenId[0] = 1;
        // creatorTokenAmount
        uint256[]  memory executerTokenAmount = new uint256[](1);
        executerTokenAmount[0] = totalAmount;
        //creatorTokenType
        uint8[]  memory executerTokenType = new uint8[](1);
        executerTokenType[0] = 1;


        uint256 tradeID =  Web3BazaarEscrow(_bazaarContract).startTrade( creatorTokenAddress, creatorTokenId, creatorTokenAmount, creatorTokenType,  
                msg.sender , executerTokenAddress,  executerTokenId, executerTokenAmount, executerTokenType );        
        
        return tradeID;
    }

    // burn own tokens
    function burnOwn(uint256 tokenId) public isOwner{
        _burn(tokenId);
    }

    //approve ERC721 used to approve bazaar contract to spend 
    function approveERC721(address erc721Address, address to,  bool approved) public isOwner
    {
        ERC721(erc721Address).setApprovalForAll( to, approved);
    }
    //transfer nft tokens
    function transferERC721(address erc721Address,address from, address to,  uint256 tokenId) public isOwner
    {
       ERC721(erc721Address).safeTransferFrom(from, to , tokenId, '');
    }

     // approve erc20
    function approveERC20(address tokenAddress, address spender,  uint256 amount) public isOwner{
         IERC20(tokenAddress).approve( spender , amount);
    }
    // transfer erc20
    function transferERC20(address tokenAddress, address to,  uint256 amount) public isOwner{
         IERC20(tokenAddress).transfer(msg.sender, amount);
    }

    
    //set price
    function setPriceByType(uint8 raffleType, uint256 newPrice) public returns (bool){
         if(raffleType == BRONZE){
             BRONZE_PRICE = newPrice;
         }else if(raffleType == SILVER){
             SILVER_PRICE = newPrice;
         }else if(raffleType == GOLD){
             GOLD_PRICE = newPrice;
         }
        return true;
    }

    // set projectToken address
    function setTokenAddress(address projectToken) external isOwner() {
        _projectTokenAddress = projectToken;
    }

    // set bazaar contract address
    function setWeb3Bazaarcontract(address newAddress) external isOwner() {
        _bazaarContract = newAddress;
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