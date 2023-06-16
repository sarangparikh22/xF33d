// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.13;

import "forge-std/Script.sol";

import {xF33dSender} from "../src/xF33dSender.sol";
import {xF33dAdapterChainlink} from "../src/chainlink/xF33dAdapterChainlink.sol";
import {xF33dReceiverChainlink} from "../src/chainlink/xF33dReceiverChainlink.sol";

contract xF33dSenderScript is Script {
    function setUp() public {}

    function run() public {
        // address lzEndpointArbitrum = 0x3c2269811836af69497E5F486A85D7316753cf62;
        // uint16 chainIdArbitrum = 110;

        // address lzEndpointNova = 0x4EE2F9B7cf3A68966c370F3eb2C16613d3235245;
        // uint16 chainIdNova = 175;

        // vm.createSelectFork("https://rpc.ankr.com/arbitrum");
        // vm.startBroadcast();

        // // arbitrum
        // xF33dSender senderArbitrum = new xF33dSender(
        //     lzEndpointArbitrum,
        //     chainIdArbitrum
        // );

        // xF33dAdapterChainlink chainlinkAdapterArbitrum = new xF33dAdapterChainlink();

        // vm.stopBroadcast();

        // vm.createSelectFork("https://nova.arbitrum.io/rpc");
        // vm.startBroadcast();

        // // arbitrum nova
        // xF33dSender senderNova = new xF33dSender(lzEndpointNova, chainIdNova);

        // senderNova.setProtectedFeeds(
        //     chainIdArbitrum,
        //     address(chainlinkAdapterArbitrum),
        //     type(xF33dReceiverChainlink).creationCode
        // );

        // senderNova.setRemoteSrcAddress(
        //     chainIdArbitrum,
        //     address(senderArbitrum)
        // );
        // vm.stopBroadcast();

        // vm.createSelectFork("https://rpc.ankr.com/arbitrum");
        // vm.startBroadcast();

        // // arbitrum
        // senderArbitrum.setRemoteSrcAddress(chainIdNova, address(senderNova));
        // vm.stopBroadcast();

        // address lzEndpointGoerli = 0xbfD2135BFfbb0B5378b56643c2Df8a87552Bfa23;
        // uint16 chainIdGoerli = 10121;

        // address lzEndpointLinea = 0x6aB5Ae6822647046626e83ee6dB8187151E1d5ab;
        // uint16 chainIdLinea = 10157;

        // address lzEndpointScroll = 0xae92d5aD7583AD66E49A0c67BAd18F6ba52dDDc1;
        // uint16 chainIdScroll = 10170;

        // vm.createSelectFork("https://rpc.ankr.com/eth_goerli");
        // vm.startBroadcast();

        // // goerli
        // xF33dSender senderGoerli = new xF33dSender(
        //     lzEndpointGoerli,
        //     chainIdGoerli
        // );

        // xF33dAdapterChainlink chainlinkAdapterGoerli = new xF33dAdapterChainlink();

        // vm.stopBroadcast();

        //
        // vm.createSelectFork("https://linea-goerli.infura.io/v3/");
        // vm.startBroadcast();

        // // linea
        // xF33dSender senderLinea = new xF33dSender(
        //     lzEndpointLinea,
        //     chainIdLinea
        // );

        // senderLinea.setProtectedFeeds(
        //     chainIdGoerli,
        //     address(0xB547094c5B7df9c60e8eDF52d5194203b31Ba38C),
        //     type(xF33dReceiverChainlink).creationCode
        // );

        // senderLinea.setRemoteSrcAddress(chainIdGoerli, address(0xb246e0f9bE42d9f0e21161860af1AeFac3DAD000));
        // vm.stopBroadcast();
        //

        // vm.createSelectFork(
        //     "https://alpha-rpc.scroll.io/l2"
        // );
        // vm.startBroadcast();

        // // scroll
        // xF33dSender senderScroll = new xF33dSender(
        //     lzEndpointScroll,
        //     chainIdScroll
        // );

        // senderScroll.setProtectedFeeds(
        //     chainIdGoerli,
        //     address(0xB547094c5B7df9c60e8eDF52d5194203b31Ba38C),
        //     type(xF33dReceiverChainlink).creationCode
        // );

        // senderScroll.setRemoteSrcAddress(
        //     chainIdGoerli,
        //     address(0xb246e0f9bE42d9f0e21161860af1AeFac3DAD000)
        // );
        // vm.stopBroadcast();
    }
}
