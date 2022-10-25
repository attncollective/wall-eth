// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import '@chainlink/contracts/src/v0.8/AutomationCompatible.sol';
import '@chainlink/contracts/src/v0.8/ChainlinkClient.sol';

contract AutomationBot is AutomationCompatibleInterface, ChainlinkClient {
    using Chainlink for Chainlink.Request;

    // Use an interval in seconds and a timestamp to slow execution of Upkeep
    uint public immutable i_interval;
    uint public immutable i_lastTimeStamp;
    uint256 private immutable i_truflationOracleFee;
    bytes32 private immutable i_truflationOracleJobId;
    uint256 public s_yoyInflation; // Current inflation variable
    uint256 public s_consumerSentiment; // Current consumer sentiment

    event RequestInflation(bytes32 indexed requestId, uint256 inflation);

    constructor(
        uint updateInterval,
        uint256 oracleFee,
        uint256 truflationOracleFee,
        bytes32 truflationOracleJobId
    ) {
        // Initialize chainlink automation
        i_interval = updateInterval;
        i_lastTimeStamp = block.timestamp;

        // Initialize truflation oracle
        i_truflationOracleFee = truflationOracleFee;
        i_truflationOracleJobId = truflationOracleJobId;
    }

    function checkUpkeep(
        bytes calldata /* checkData */
    )
        external
        view
        override
        returns (
            bool upkeepNeeded,
            bytes memory /* performData */
        )
    {
        // Retrieve truflation data
        s_yoyInflation = requestInflationData();
        s_consumerSentiment = requestConsumerSentimentData();

        // Check if the conditions indicate wheter we need to make a trade or not
        upkeepNeeded = s_yoyInflation * s_consumerSentiment > 1;

        // We don't use the checkData in this example. The checkData is defined when the Upkeep was registered.
    }

    function performUpkeep(
        bytes calldata /* performData */
    ) external override {
        // TODO: BUY / SELL
        // We highly recommend revalidating the upkeep in the performUpkeep function
    }

    // Create a Chainlink request to retrieve API response, find the target data
    function requestInflationData() public returns (uint256 yoyInflation) {
        // Chainlink.Request memory req = buildChainlinkRequest(jobId, address(this), this.fulfill.selector);
        // return sendChainlinkRequest(req, fee);
        uint256 foo = 1;
        return foo;
    }

    // Create a Chainlink request to retrieve API response, find the target data
    function requestConsumerSentimentData() public returns (uint256 consumerSentiment) {
        // Chainlink.Request memory req = buildChainlinkRequest(jobId, address(this), this.fulfill.selector);
        // return sendChainlinkRequest(req, fee);
        uint256 foo = 1;
        return foo;
    }
}
