// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "./Crowdfunding.sol";
import "./InsuranceContract.sol";
import "./FarmSureToken.sol";

contract FarmSure {
    Crowdfunding public crowdfunding;
    Insurance public insurance;
    FarmSureToken public token;

    constructor(address _crowdfunding, address _insurance, address _token) {
        crowdfunding = Crowdfunding(_crowdfunding);
        insurance = Insurance(_insurance);
        token = FarmSureToken(_token);
    }

    // Example: Reward funders after successful crowdfunding
    function rewardFunders(uint256 _projectId) external {
        // Logic to distribute tokens to funders based on their contribution
        // Call functions from Crowdfunding and Token contracts
    }
}
