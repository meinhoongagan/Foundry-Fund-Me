// SPDX-License-Identifier: MIT

pragma solidity 0.8.26;

import {PriceConverter} from "./PriceConverter.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract FundMe{
    using PriceConverter for uint256;
    uint256 public constant MINUSD= 5e18;
    address[] public funders;
    mapping(address => uint256) addressToAmmountFunded ;
    address public immutable owner ;
    constructor () {
        owner = msg.sender;
    }

    error FundMe__NotOwner();

    function fund () public payable {
        require(msg.value.getConvertedPrice() >= MINUSD,"Didn't Send Enough ETH");
        funders.push(msg.sender);
        addressToAmmountFunded[msg.sender] += msg.value;
    }

    function getVersion () public view returns(uint256)  {
        return AggregatorV3Interface(0xfEefF7c3fB57d18C5C6Cdd71e45D2D0b4F9377bF).version();
    }

    function withdraw () public onlyOwner {
        for(uint256 funderIndex = 0;funderIndex<funders.length;funderIndex++){
             addressToAmmountFunded[funders[funderIndex]] = 0;
        }
        funders = new address[](0);

        // //transfer
        // payable(msg.sender).transfer(address(this).balance);

        // //send
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess,"Send Failed");

        //call 
        (bool callSuccess , ) = payable(msg.sender).call{value : address(this).balance}("");
         require(callSuccess,"Call Failed");

    }

    modifier onlyOwner () { 
        // require(msg.sender == owner);
        if(msg.sender != owner) {revert FundMe__NotOwner();}
        _;
    }

    receive() external payable { 
        fund();
     }
    fallback() external payable { 
        fund();
     }
}