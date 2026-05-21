// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MockOracle {
    mapping(address => uint256) public prices;
    
    function setPrice(address asset, uint256 price) external {
        prices[asset] = price;
    }
    
    function getPrice(address asset) external view returns (uint256) {
        if (prices[asset] == 0) {
            return 300000000000; // 默认 3000 USD (8 decimals)
        }
        return prices[asset];
    }
}