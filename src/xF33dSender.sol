// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.13;

import {Ownable2Step} from "openzeppelin/access/Ownable2Step.sol";

import {ILayerZeroEndpoint} from "solidity-examples/interfaces/ILayerZeroEndpoint.sol";
import {ILayerZeroReceiver} from "solidity-examples/interfaces/ILayerZeroReceiver.sol";

import {IxF33dAdapter} from "./interfaces/IxF33dAdapter.sol";
import {IxF33dReceiver} from "./interfaces/IxF33dReceiver.sol";

contract xF33dSender is Ownable2Step, ILayerZeroReceiver {
    ILayerZeroEndpoint public lzEndpoint;
    mapping(bytes32 => address) public activatedFeeds;
    mapping(uint16 => address) public remoteSrcAddress;
    mapping(bytes32 => bytes) public protectedFeeds;
    uint16 public chainId;

    constructor(address _endpoint, uint16 _chainId) {
        lzEndpoint = ILayerZeroEndpoint(_endpoint);
        chainId = _chainId;
    }

    event SentUpdatedRate(
        uint16 _chainId,
        address _feed,
        bytes _feedData,
        bytes _payload
    );
    event FeedDeployed(
        uint16 _chainId,
        address _feed,
        bytes _feedData,
        address receiver
    );
    event FeedActivated(bytes32 _feedId, address _receiver);
    event SetRemoteSrcAddress(uint16 _chainId, address _remoteSrcAddress);
    event SetProtectedFeeds(uint16 _chainId, address _feed);
    event SetLzEndpoint(address _lzEndpoint);

    function sendUpdatedRate(
        uint16 _chainId,
        address _feed,
        bytes calldata _feedData
    ) external payable {
        bytes32 _feedId = keccak256(abi.encode(_chainId, _feed, _feedData));
        address _receiver = activatedFeeds[_feedId];
        require(_receiver != address(0), "feed not active");

        bytes memory _payload = IxF33dAdapter(_feed).getLatestData(_feedData);

        lzEndpoint.send{value: msg.value}(
            _chainId,
            abi.encodePacked(_receiver, address(this)),
            _payload,
            payable(msg.sender),
            address(0),
            bytes("")
        );

        emit SentUpdatedRate(_chainId, _feed, _feedData, _payload);
    }

    function deployFeed(
        uint16 _chainId,
        address _feed,
        bytes calldata _feedData,
        bytes memory _bytecode
    ) external payable returns (address) {
        if (protectedFeeds[keccak256(abi.encode(_chainId, _feed))].length > 0)
            _bytecode = protectedFeeds[keccak256(abi.encode(_chainId, _feed))];

        bytes32 salt = keccak256(
            abi.encode(_chainId, _feed, _feedData, _bytecode)
        );

        address receiver;

        assembly {
            receiver := create2(0, add(_bytecode, 0x20), mload(_bytecode), salt)

            if iszero(extcodesize(receiver)) {
                revert(0, 0)
            }
        }

        IxF33dReceiver(receiver).init(
            address(lzEndpoint),
            remoteSrcAddress[_chainId]
        );

        lzEndpoint.send{value: msg.value}(
            _chainId,
            abi.encodePacked(remoteSrcAddress[_chainId], address(this)),
            abi.encode(
                keccak256(abi.encode(chainId, _feed, _feedData)),
                receiver
            ),
            payable(msg.sender),
            address(0),
            bytes("")
        );

        emit FeedDeployed(_chainId, _feed, _feedData, receiver);

        return receiver;
    }

    function lzReceive(
        uint16 _chainId,
        bytes memory _srcAddress,
        uint64,
        bytes calldata _payload
    ) public virtual override {
        require(msg.sender == address(lzEndpoint));
        address remoteSrc;
        assembly {
            remoteSrc := mload(add(_srcAddress, 20))
        }
        require(remoteSrc == remoteSrcAddress[_chainId]);
        (bytes32 _feedId, address _receiver) = abi.decode(
            _payload,
            (bytes32, address)
        );

        activatedFeeds[_feedId] = _receiver;

        emit FeedActivated(_feedId, _receiver);
    }

    function setRemoteSrcAddress(
        uint16 _chainId,
        address _remoteSrcAddress
    ) external onlyOwner {
        remoteSrcAddress[_chainId] = _remoteSrcAddress;
        emit SetRemoteSrcAddress(_chainId, _remoteSrcAddress);
    }

    function setProtectedFeeds(
        uint16 _chainId,
        address _feed,
        bytes calldata _bytecode
    ) external onlyOwner {
        protectedFeeds[keccak256(abi.encode(_chainId, _feed))] = _bytecode;
        emit SetProtectedFeeds(_chainId, _feed);
    }

    function setLzEndpoint(address _lzEndpoint) external onlyOwner {
        lzEndpoint = ILayerZeroEndpoint(_lzEndpoint);
        emit SetLzEndpoint(_lzEndpoint);
    }

    function getFeesForRateUpdate(
        uint16 _chainId,
        address _feed,
        bytes calldata _feedData
    ) external view returns (uint256 fees) {
        bytes memory _payload = IxF33dAdapter(_feed).getLatestData(_feedData);
        (fees, ) = lzEndpoint.estimateFees(
            _chainId,
            address(this),
            _payload,
            false,
            bytes("")
        );
    }

    function getFeesForDeployFeed(
        uint16 _chainId,
        address _feed,
        bytes calldata _feedData
    ) external view returns (uint256 fees) {
        (fees, ) = lzEndpoint.estimateFees(
            _chainId,
            address(this),
            abi.encode(
                keccak256(abi.encode(chainId, _feed, _feedData)),
                address(0)
            ),
            false,
            bytes("")
        );
    }
}
