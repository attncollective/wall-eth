//TODO: Disable transfers for non-operators


// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "erc721a/contracts/ERC721A.sol";
import "./interfaces/TruflationClient.sol";


/**
 * LP token representing proof of deposit
 */

contract RobotNFT is ERC721A {

    /**
     * Contract variables
     */
    mapping(address => bool) public operator;
    mapping(string => string) public tokenURIs;
    bool public transferrable = false;

    /**
     * Chainlink variables
     * Upkeep is handled by TradingBot
     */
    TruflationClient truflationClient;
    address public oracleAddress; // Chainlink feed address to recieve current data
    
    /**
     * Modifiers
     */
    modifier onlyOperator() {
        require(operator[msg.sender] == true, "You must be a operator!");
        _;
    }

    constructor() ERC721A("Robot", "NFT") {
        tokenURIs["happy"] = "url0";
        tokenURIs["stressed"] = "url1";
        tokenURIs["sad"] = "url2";
    }

    /**
     * Must be a operator to mint
     */
    function mint(uint256 quantity) external payable onlyOperator {
        _mint(msg.sender, quantity);
    }

    /**
     *
     */
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

    function getInflation() public returns (uint256) {
        return truflationClient().inflation();
    }

    /**
     * Disable transfers
     */
    function transferFrom(address _from, address _to, uint256 _tokenId) public payable override{
        _from;
        _to;
        _tokenId;
        require(transferrable, "Cant transfer unless allowed!");
    }

    /**
     * Update the oracle address
     */
    function setOracleAddress(address _oracleAddress) public onlyOperator {
        truflationClient = TruflationClient(_oracleAddress);
    }

}