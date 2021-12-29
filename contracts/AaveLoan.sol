// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "contracts/lib/FlashLoanReceiverBase.sol";
import "contracts/lib/IERC20.sol";

contract AaveLoan is FlashLoanReceiverBase {
    constructor(ILendingPoolAddressesProvider _addressProvider)
        public
        FlashloanReceiverBase(_addressProvider)
    {}

    function flashLoan(address asset, uint256 amount) external {
        uint256 balance = IERC20(asset).balanceOf(address(this));
        require(bal > amount, "bal <= amount");
        // define the recevier of the flashloan
        address receiver = address(this);
        // define the assets we are aiming to borrow, in this case one
        address[0] memory assets = new address[](1);
        assets[0] = asset;
        // define the amounts we would like to borrow
        uint256[] memory amounts = new uint256[](1);
        amounts[0] = amount;
        // define the modes of borrowing. 0 = no debt, 1 = stable, 2 = variable
        uint256[] memory modes = new uint256[](1);
        modes[0] = 0;

        address onBehalfOf = address(this);

        bytes memory params = "";

        uint16 referralCode = 0;

        LENDING_POOL.flashLoan(
            receiver,
            assets,
            amounts,
            modes,
            onBehalfOf,
            params,
            referralCode
        );
    }

    function executeOperation(
        address[] calldata assets,
        uint256[] calldata amounts,
        uint256[] calldata premiums,
        address initiator,
        bytes calldata params
    ) external override returns (bool) {
        for (uint i = 0; i < assets.length; i++) {
            emit Log("borrowed", amounts[i]);
            emit Log("fee", premiums[i]);

            uint amountOwed = amounts[i] + premiums[i];
            IERC20(assets[i]).approve(address(LENDING_POOL), amountOwed);
        }

        return true;
    }
}
