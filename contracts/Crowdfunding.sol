// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Crowdfunding {
    struct Project {
        address payable farmer;
        string description;
        uint256 goalAmount;
        uint256 raisedAmount;
        bool isFunded;
        mapping(address => uint256) contributions;
    }

    uint256 public projectCount;
    mapping(uint256 => Project) public projects;
    IERC20 public token;

    event ProjectCreated(uint256 projectId, address farmer, string description, uint256 goalAmount);
    event Funded(uint256 projectId, address funder, uint256 amount);
    event FundsWithdrawn(uint256 projectId);

    constructor(address _token) {
        token = IERC20(_token);
    }

    function createProject(string memory _description, uint256 _goalAmount) external {
        require(_goalAmount > 0, "Goal amount must be greater than 0");
        projectCount++;
        Project storage newProject = projects[projectCount];
        newProject.farmer = payable(msg.sender);
        newProject.description = _description;
        newProject.goalAmount = _goalAmount;
        emit ProjectCreated(projectCount, msg.sender, _description, _goalAmount);
    }

    function fundProject(uint256 _projectId, uint256 _amount) external {
        Project storage project = projects[_projectId];
        require(!project.isFunded, "Project already funded");
        require(_amount > 0, "Funding amount must be greater than 0");

        token.transferFrom(msg.sender, address(this), _amount);
        project.raisedAmount += _amount;
        project.contributions[msg.sender] += _amount;

        if (project.raisedAmount >= project.goalAmount) {
            project.isFunded = true;
        }

        emit Funded(_projectId, msg.sender, _amount);
    }

    function withdrawFunds(uint256 _projectId) external {
        Project storage project = projects[_projectId];
        require(msg.sender == project.farmer, "Only the farmer can withdraw");
        require(project.isFunded, "Project not fully funded");

        uint256 amount = project.raisedAmount;
        project.raisedAmount = 0;
        project.farmer.transfer(amount);

        emit FundsWithdrawn(_projectId);
    }
}
