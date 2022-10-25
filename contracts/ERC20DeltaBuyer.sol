// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// import "@chainlink/contracts/src/v0.8/AutomationCompatible.sol";
// import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";
// import "@chainlink/contracts/src/v0.8/ConfirmedOwner.sol";

contract ERC20DeltaBuyer 
    // is
    // AutomationCompatibleInterface,
    // ChainlinkClient,
    // ConfirmedOwner
{
    // using Chainlink for Chainlink.Request;

    bytes32 private jobId;
    uint256 private fee;
    uint256 public constant tokenPrice = 5;

    /**
     * Current inflation variable
     */
    uint256 public yoyInflation;

    /**
     * Current consumer sentiment
     */
    uint256 public consumerSentiment;

    event RequestInflation(bytes32 indexed requestId, uint256 inflation);

    /**
     * Use an interval in seconds and a timestamp to slow execution of Upkeep
     */
    uint256 public immutable interval;
    uint256 public lastTimeStamp;

    constructor(uint256 updateInterval) {
        // Initialize chainlink automation
        interval = updateInterval;
        lastTimeStamp = block.timestamp;
        // Initialize truflation oracle
        // setChainlinkToken(); // get token, oracle
        // setChainlinkOracle();
        // jobId = "tests";
        // fee = (1 * LINK_DIVISIBILITY) / 10; // 0,1 * 10**18 (Varies by network and job)

        // call chainlink on contract initialization ?
    }

    function checkUpkeep(
        bytes calldata /* checkData */
    )
        external
        view
        returns (
            bool upkeepNeeded,
            bytes memory /* performData */
        )
    {
        // Retrieve truflation data
        uint _yoyInflation = requestInflationData();
        uint _consumerSentiment = requestConsumerSentimentData();
        upkeepNeeded = _yoyInflation * _consumerSentiment > 0; // test case
        // We don't use the checkData in this example. The checkData is defined when the Upkeep was registered.
        return (upkeepNeeded, abi.encodePacked(_yoyInflation, _consumerSentiment));
    }

    function performUpkeep(
        bytes calldata /* performData */
    ) external {
        //We highly recommend revalidating the upkeep in the performUpkeep function
        
        // TODO: BUY / SELL
        
    }

    // Temporary function
    function requestInflationData() public pure returns (uint inflation) {
        return 3;
    }

    function requestConsumerSentimentData() public pure returns (uint inflation) {
        return 40;
    }

    /**
     * Create a Chainlink request to retrieve API response, find the target
     * data
     */
    // function requestInflationData() public returns (bytes32 requestId) {
    // 	Chainlink.request memory req = buildChainlinkRequest(jobId, address(this), this.fulfill.selector);

    // 	// TODO: find proper URL for GET request
    // 	req.add("get", /* get url*/);
    // 	// inflation specific data
    // 	req.add("get", /* get data */);
    // 	//
    // 	return sendChainlinkRequest(req, fee);
    // }
}
