// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import {LZEndpointMock} from "solidity-examples/mocks/LZEndpointMock.sol";
import {xF33dSender} from "../src/xF33dSender.sol";
import {xF33dAdapterChainlink} from "../src/chainlink/xF33dAdapterChainlink.sol";
import {xF33dReceiverChainlink} from "../src/chainlink/xF33dReceiverChainlink.sol";
import {AggregatorV3Interface} from "../src/interfaces/AggregatorV3Interface.sol";

contract xF33dChainlinkTest is Test {
    LZEndpointMock srcEndpoint;
    LZEndpointMock dstEndpoint;

    uint16 CHAIN_ID_1;
    uint16 CHAIN_ID_2;

    xF33dSender chain1Sender;
    xF33dSender chain2Sender;

    xF33dAdapterChainlink chainlinkAdapter;
    xF33dReceiverChainlink receiverChainlink;

    address ethPriceFeed = 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419; // ethereum mainnet

    uint80 roundId;
    int price;
    uint256 startedAt;
    uint256 timestamp;
    uint80 answeredInRound;

    function setUp() public {
        srcEndpoint = new LZEndpointMock(CHAIN_ID_1);
        dstEndpoint = new LZEndpointMock(CHAIN_ID_2);

        chain1Sender = new xF33dSender(address(srcEndpoint), CHAIN_ID_1);
        chain2Sender = new xF33dSender(address(dstEndpoint), CHAIN_ID_2);

        srcEndpoint.setDestLzEndpoint(
            address(chain2Sender),
            address(dstEndpoint)
        );

        dstEndpoint.setDestLzEndpoint(
            address(chain1Sender),
            address(srcEndpoint)
        );

        chain1Sender.setRemoteSrcAddress(CHAIN_ID_2, address(chain2Sender));
        chain2Sender.setRemoteSrcAddress(CHAIN_ID_1, address(chain1Sender));

        chainlinkAdapter = new xF33dAdapterChainlink();

        (
            roundId,
            price,
            startedAt,
            timestamp,
            answeredInRound
        ) = AggregatorV3Interface(ethPriceFeed).latestRoundData();
    }

    function testDeployAndFetchRate() external {
        address receiver = chain2Sender.deployFeed{value: 1 ether}(
            CHAIN_ID_1,
            address(chainlinkAdapter),
            abi.encode(ethPriceFeed),
            type(xF33dReceiverChainlink).creationCode
        );

        assert(xF33dReceiverChainlink(receiver).lzEndpoint() == dstEndpoint);

        srcEndpoint.setDestLzEndpoint(address(receiver), address(dstEndpoint));

        chain1Sender.sendUpdatedRate{value: 1 ether}(
            CHAIN_ID_2,
            address(chainlinkAdapter),
            abi.encode(ethPriceFeed)
        );

        (
            uint80 _roundId,
            int _price,
            uint256 _startedAt,
            uint256 _timestamp,
            uint80 _answeredInRound
        ) = xF33dReceiverChainlink(receiver).latestRoundData();

        assert(roundId == _roundId);
        assert(price == _price);
        assert(startedAt == _startedAt);
        assert(timestamp == _timestamp);
        assert(answeredInRound == _answeredInRound);
    }

    function testProtectedFeeds() external {
        chain2Sender.setProtectedFeeds(
            CHAIN_ID_1,
            address(chainlinkAdapter),
            type(xF33dReceiverChainlink).creationCode
        );

        address receiver = chain2Sender.deployFeed{value: 1 ether}(
            CHAIN_ID_1,
            address(chainlinkAdapter),
            abi.encode(ethPriceFeed),
            bytes("")
        );

        assert(xF33dReceiverChainlink(receiver).lzEndpoint() == dstEndpoint);

        srcEndpoint.setDestLzEndpoint(address(receiver), address(dstEndpoint));

        chain1Sender.sendUpdatedRate{value: 1 ether}(
            CHAIN_ID_2,
            address(chainlinkAdapter),
            abi.encode(ethPriceFeed)
        );

        (
            uint80 _roundId,
            int _price,
            uint256 _startedAt,
            uint256 _timestamp,
            uint80 _answeredInRound
        ) = xF33dReceiverChainlink(receiver).latestRoundData();

        assert(roundId == _roundId);
        assert(price == _price);
        assert(startedAt == _startedAt);
        assert(timestamp == _timestamp);
        assert(answeredInRound == _answeredInRound);
    }

    receive() external payable {}
}
