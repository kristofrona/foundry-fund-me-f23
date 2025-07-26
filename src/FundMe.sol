// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./PriceConverter.sol";

error NotOwner();

contract FundMe {
    using PriceConverter for uint256;

    uint256 public constant MINIMUM_USD = 5e18;

    address public immutable i_owner;
    AggregatorV3Interface public s_priceFeed; // ✅ You MUST declare this

    constructor(AggregatorV3Interface _priceFeed) {
        i_owner = msg.sender;
        s_priceFeed = _priceFeed; // ✅ This line now works because s_priceFeed is declared
    }

    function fund() public payable {
        require(
            msg.value.getConversionRate(s_priceFeed) >= MINIMUM_USD,
            "You need to spend more ETH!"
        );
    }

    modifier onlyOwner() {
        if (msg.sender != i_owner) revert NotOwner(); // ✅ Declared above
        _;
    }

    // add withdraw(), fallback(), etc. if needed
}
