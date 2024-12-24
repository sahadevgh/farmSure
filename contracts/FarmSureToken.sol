// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract FarmSureToken is ERC20 {
    address public admin;

    constructor() ERC20("FarmSureToken", "FST") {
        admin = msg.sender;
        _mint(msg.sender, 1_000_000 * 10 ** decimals()); // Initial supply
    }

    function mint(address to, uint256 amount) external {
        require(msg.sender == admin, "Only admin can mint");
        _mint(to, amount);
    }
}
