# xF33d - _Cross Chain Oracle Feed_

xF33d is a cross chain based Oracle Feed provider. It uses LayerZero at the cross chain message layer to pass oracle data from one chain to another. It is especially useful when you want to use "trusted" oracle services like Chainlink on the other chain where it does not exists or for tokens whose feeds might be missing on some chains. You can pass any custom oracle data by deploying new feeds that everyone can use.

To mirror a chainlink feed from another network - 

1) Get or Deploy the chainlink adapter. It should be most likely deployed. If not you can deploy or contact me.

2) On the dest network, deployFeed() with LayerZero chainId of source, chainlink adapter feed, feed data (abi encode of chainlink feed address for that pair), bytecode of the receiver (if it's protected feed, you can leave this blank)

3) On the source chain call the sendUpdateRate with LayerZero chainId of dest, chainlink adapter feed, feed data (abi encode of chainlink feed address for that pair).

4) You can verify the update on the receiver contract, which now acts as oracle for your application.

You can use this with any oracle or any feed transfer cross chain, chainlink is used an example. 

## Deployments

Arbitrum xF33dSender - https://arbiscan.io/address/0x2bF0de538aaB4625D86bFdf3542C9497CcF0fcD5 

Arbitrum Chainlink Adapter - https://arbiscan.io/address/0x39e90a808da5191eeb44744bc897af8edb65e3fc

Arbitrum Nova xF33dSender - https://nova.arbiscan.io/address/0x0dd184bec9e43701f76d75d5fffe246b2dc8d4ea

Arbitrum Nova xF33dReceiverChainlink (ETH/USD)- https://nova.arbiscan.io/address/0x76778dab0570adcc56dea21f1e096eec6af1d14d#readContract

Update Transaction on LayerZero Scan - https://layerzeroscan.com/110/address/0x2bf0de538aab4625d86bfdf3542c9497ccf0fcd5/message/175/address/0x76778dab0570adcc56dea21f1e096eec6af1d14d/nonce/1

## Test Transactions

Arbitrum Nova Deploy Feed Transaction - https://nova.arbiscan.io/tx/0x27e1ff7f882a13f7f2c1e9c5bcdec0c6fe757c538fa86c1fbb8f5dd564bba030

Arbitrum Update Rate Transaction - https://arbiscan.io/tx/0xb455c7d4fc4db004c462fcb7c18d5e8d64f6d1237286fce8db34649abe2b128c

## Usage

You will need a copy of [Foundry](https://github.com/foundry-rs/foundry) installed before proceeding. See the [installation guide](https://github.com/foundry-rs/foundry#installation) for details.

To build the contracts:

```sh
git clone https://github.com/sarangparikh22/xF33d.git
cd xF33d
forge install
```

### Run Tests

In order to run unit tests, run:

```sh
forge test
```
