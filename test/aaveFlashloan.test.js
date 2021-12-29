const BN = require("bn.js");
const {sendEther, pow} = require("./util");
const { DAI, DAI_WHALE, USDC, USDC_WHALE, USDT, USDT_WHALE, ADDRESS_PROVIDER } = require("./config");
const { assert } = require("console");

const IERC20 = artifacts.require("IERC20");
const AaveFlashLoan = artifacts.require("AaveFlashLoan");

contract("AaveFlashloan", (accounts) => {
    const DECIMALS = 6;
    const FUND_AMOUNT = pow(10, DECIMALS).mul(new BN(2000));
    const BORROW_AMOUNT = pow(10, DECIMALS).mul(new BN(1000));

    let aaveFlashLoan;
    let token;

    beforeEach(async () => {
        token = await IERC20.at(USDC);
        aaveFlashLoan = await AaveFlashLoan.new(ADDRESS_PROVIDER);

        await sendEther(web3, accounts[0], USDC_WHALE, 1);

        const bal = await token.balanceOf(USDC_WHALE);

        assert(bal.gte(FUND_AMOUNT), "balance < FUND amount");
        await token.transfer(aaveFlashLoan.address, FUND_AMOUNT, {from: USDC_WHALE});
    })

    it("should perform the flash loan and log results", async () => {
        const tx = await aaveFlashLoan.flashLoan(token.address, BORROW_AMOUNT, { from: USDC_WHALE })

        for (const log of tx.logs) {
            console.log(log.args.message, log.args.val.toString());
        }
    })

})