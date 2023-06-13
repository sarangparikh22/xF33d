// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.13;

import {ILayerZeroEndpoint} from "solidity-examples/interfaces/ILayerZeroEndpoint.sol";
import {ILayerZeroReceiver} from "solidity-examples/interfaces/ILayerZeroReceiver.sol";

contract xF33dReceiver is ILayerZeroReceiver {
    ILayerZeroEndpoint public lzEndpoint;
    address public srcAddress;

    bytes public oracleData;
    uint32 public lastUpdated;

    function init(address _endpoint, address _srcAddress) public {
        lzEndpoint = ILayerZeroEndpoint(_endpoint);
        srcAddress = _srcAddress;
    }

    function lzReceive(
        uint16,
        bytes memory _srcAddress,
        uint64,
        bytes calldata _payload
    ) public virtual override {
        require(msg.sender == address(lzEndpoint));
        address remoteSrc;
        assembly {
            remoteSrc := mload(add(_srcAddress, 20))
        }
        require(remoteSrc == srcAddress);

        oracleData = _payload;
        lastUpdated = uint32(block.timestamp);
    }
}
