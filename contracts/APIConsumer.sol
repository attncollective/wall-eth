```js

pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";

contract APIConsumer is ChainlinkClient {
    using Chainlink for Chainlink.Request;

    uint256 public price;

    address private oracle;
    bytes32 private jobId;
    uint256 private fee;


    constructor() {
        setChainlinkToken(0x84b9B910527Ad5C03A9Ca831909E21e236EA7b06);
        oracle = 0x19f7f3bF88CB208B0C422CC2b8E2bd23ee461DD1;
        jobId = "7d80a6386ef543a3abb52817f6707e3b";
        fee = 0.0001 * 10 ** 18; // (Varies by network and job)
    }

    function requestPriceData() public returns (bytes32 requestId)
    {
        Chainlink.Request memory request = buildChainlinkRequest(jobId, address(this), this.fulfill.selector);
        request.add("get", "https://min-api.cryptocompare.com/data/price?fsym=ETH&tsyms=USD&api_key={e55293715a43d47ebfc785d0614d09f558705968b9da8d083bc1d3ab23813744}");
        request.add("path", "price");

        // Multiply the result by 1000000000000000000 to remove decimals
        int timesAmount = 10**18;
        request.addInt("times", timesAmount);

        // Sends the request
        return sendChainlinkRequestTo(oracle, request, fee);
    }

    function fulfill(bytes32 _requestId, uint256 _price) public recordChainlinkFulfillment(_requestId)
    {
        price = _price;
    }


}
