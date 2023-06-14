# xF33d - _Cross Chain Oracle Feed_

xF33d is a cross chain based Oracle Feed provider. It uses LayerZero at the cross chain message layer to pass oracle data from one chain to another. It is especially useful when you want to use "trusted" oracle services like Chainlink on the other chain where it does not exists or for tokens whose feeds might be missing on some chains. You can pass any custom oracle data by deploying new feeds that everyone can use.

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

