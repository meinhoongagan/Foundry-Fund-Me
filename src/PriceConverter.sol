// SPDX-License-Identifier: MIT

pragma solidity 0.8.26;
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    
    function getPrice () public view returns(uint256) {
        (,int256 price ,,,) = AggregatorV3Interface(0xfEefF7c3fB57d18C5C6Cdd71e45D2D0b4F9377bF).latestRoundData();
        return uint256(price * 1e10);
    }

    function getConvertedPrice (uint256 ethAmmount) public view returns(uint256) {
        uint256 eth = getPrice();
        uint256 ethToUsd = (eth *ethAmmount) / 1e18 ;
        return ethToUsd;
    }

}
