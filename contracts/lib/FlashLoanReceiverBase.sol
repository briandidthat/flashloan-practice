// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./IFlashLoanReceiver.sol";
import "./ILendingPoolAddressesProvider.sol";
import "./ILendingPool.sol";


abstract contract FlashloanReceiverBase is IFlashLoanReceiver {
    ILendingPoolAddressesProvider public immutable ADDRESSES_PROVIDER;
    ILendingPool public immutable LENDING_POOL;

    constructor(ILendingPoolAddressesProvider provider) {
        ADDRESSES_PROVIDER = provider;
        LENDING_POOL = ILendingPool(provider.getLendingPool());
    }
}