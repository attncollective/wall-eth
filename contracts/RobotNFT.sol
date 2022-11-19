// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "erc721a/contracts/extensions/ERC721ABurnable.sol";
import "./interfaces/TruflationClient.sol";


/**
 * LP token representing proof of deposit
 */

contract RobotNFT is ERC721A {

    // Public variables
    mapping(address => bool) public operator;
    mapping(string => string) public tokenURIs;
    bool public transferrable = false;

    // Chainlink Variales
    TruflationClient truflationClient;
    address public oracleAddress; // Chainlink feed address to recieve current data
    
    /**
     * Modifiers
     */
    modifier onlyOperator() {
        require(operator[msg.sender] == true, "You must be a operator!");
        _;
    }

    modifier whenTransferable() {
        require(transferrable, "You can't transfer this token");
        _;
    }

    constructor(address _oracleAddress) ERC721A("Robot", "NFT") {
        setOracleAddress(_oracleAddress);
        operator[msg.sender] = true;
        
        tokenURIs["happy"] = "url0";
        tokenURIs["stressed"] = "url1";
        tokenURIs["sad"] = "url2";
    }

    /*
     @notice: mint is for TradingBot contract

     The following checks occur, it checks:
      - that the sender is a operator

     Upon passing checks it calls the internal _mint function to perform
     the minting.
     */
    function mint(uint256 quantity) external payable onlyOperator {
        _mint(msg.sender, quantity);
    }

    /*
     @notice: burn is for TradingBot contract

     The following checks occur, it checks:
      - that the sender is a operator

     Upon passing checks it calls the internal _burn function to perform
     the minting.
     */
    function burn(uint256 tokenId) public onlyOperator {
        _burn(tokenId, false);
    }

    function tokenURI(uint256 tokenId) public view override (ERC721A) returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

        uint256 inflation = getInflation();

        if(inflation <= 3) {
            return tokenURIs["happy"];
        } else if(inflation > 3 && inflation <= 7) {
            return tokenURIs["stressed"];
        } else if(inflation > 7) {
            return tokenURIs["sad"];
        }
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) public payable override whenTransferable{
        super.transferFrom(_from, _to, _tokenId);
    }

    /**
     * Owner Functions
     */
    
    function setOracleAddress(address _oracleAddress) public onlyOperator {
        truflationClient = TruflationClient(_oracleAddress);
    }

    function setTransferable(bool _transferrable) external onlyOperator {
        transferrable = _transferrable;
    }

    function setOperator(address _address, bool _isOperator) external onlyOperator {
        operator[_address] = _isOperator;
    } 

    /**
     * Internal Functions
     */
    function getInflation() internal returns (uint256) {
        return truflationClient().inflation();
    }

}