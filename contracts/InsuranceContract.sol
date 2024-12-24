// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract Insurance {
    struct Policy {
        address farmer;
        uint256 premium;
        uint256 payoutAmount;
        bool isClaimed;
        bool isActive;
    }

    uint256 public policyCount;
    mapping(uint256 => Policy) public policies;

    AggregatorV3Interface public weatherOracle;

    event PolicyCreated(uint256 policyId, address farmer, uint256 premium, uint256 payoutAmount);
    event ClaimProcessed(uint256 policyId, uint256 payoutAmount);

    constructor(address _oracle) {
        weatherOracle = AggregatorV3Interface(_oracle);
    }

    function createPolicy(uint256 _premium, uint256 _payoutAmount) external payable {
        require(msg.value == _premium, "Premium must be paid in full");
        policyCount++;
        policies[policyCount] = Policy(msg.sender, _premium, _payoutAmount, false, true);
        emit PolicyCreated(policyCount, msg.sender, _premium, _payoutAmount);
    }

    function processClaim(uint256 _policyId) external {
        Policy storage policy = policies[_policyId];
        require(policy.isActive, "Policy is not active");
        require(!policy.isClaimed, "Policy already claimed");

        // Simulate weather data check (can be replaced with actual oracle logic)
        (, int256 weatherData, , , ) = weatherOracle.latestRoundData();
        require(weatherData < 1000, "Weather condition does not meet claim criteria");

        policy.isClaimed = true;
        policy.isActive = false;
        payable(policy.farmer).transfer(policy.payoutAmount);

        emit ClaimProcessed(_policyId, policy.payoutAmount);
    }
}
