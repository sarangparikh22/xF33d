// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.13;

import "forge-std/Script.sol";

import {xF33dSender} from "../src/xF33dSender.sol";
import {xF33dAdapterChainlink} from "../src/chainlink/xF33dAdapterChainlink.sol";
import {xF33dReceiverChainlink} from "../src/chainlink/xF33dReceiverChainlink.sol";

contract xF33dSenderScript is Script {
    function setUp() public {}

    function run() public {
        address lzEndpointArbitrum = 0x3c2269811836af69497E5F486A85D7316753cf62;
        uint16 chainIdArbitrum = 110;

        address lzEndpointNova = 0x4EE2F9B7cf3A68966c370F3eb2C16613d3235245;
        uint16 chainIdNova = 175;

        vm.createSelectFork("https://rpc.ankr.com/arbitrum");
        vm.startBroadcast();

        // arbitrum
        xF33dSender senderArbitrum = new xF33dSender(
            lzEndpointArbitrum,
            chainIdArbitrum
        );

        xF33dAdapterChainlink chainlinkAdapterArbitrum = new xF33dAdapterChainlink();

        vm.stopBroadcast();

        vm.createSelectFork("https://nova.arbitrum.io/rpc");
        vm.startBroadcast();

        // arbitrum nova
        xF33dSender senderNova = new xF33dSender(lzEndpointNova, chainIdNova);

        senderNova.setProtectedFeeds(
            chainIdArbitrum,
            address(chainlinkAdapterArbitrum),
            type(xF33dReceiverChainlink).creationCode
        );

        senderNova.setRemoteSrcAddress(
            chainIdArbitrum,
            address(senderArbitrum)
        );
        vm.stopBroadcast();

        // vm.createSelectFork("https://rpc.ankr.com/arbitrum");
        // vm.startBroadcast();

        // // arbitrum
        // senderArbitrum.setRemoteSrcAddress(chainIdNova, address(senderNova));
        // vm.stopBroadcast();
    }
}
