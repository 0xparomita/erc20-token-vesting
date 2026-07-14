// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract TokenVesting is ReentrancyGuard {
    event TokensReleased(address indexed beneficiary, uint256 amount);

    IERC20 public immutable token;
    address public immutable beneficiary;
    
    uint256 public immutable start;
    uint256 public immutable cliff;
    uint256 public immutable duration;
    
    uint256 public released;

    constructor(
        address _token,
        address _beneficiary,
        uint256 _start,
        uint256 _cliffDuration,
        uint256 _duration
    ) {
        require(_token != address(0), "Token address cannot be zero");
        require(_beneficiary != address(0), "Beneficiary address cannot be zero");
        require(_duration > 0, "Duration must be greater than zero");
        require(_cliffDuration <= _duration, "Cliff cannot exceed total duration");

        token = IERC20(_token);
        beneficiary = _beneficiary;
        start = _start;
        cliff = _start + _cliffDuration;
        duration = _duration;
    }

    function release() external nonReentrant {
        uint256 unreleased = releasableAmount();
        require(unreleased > 0, "No tokens are due for release");

        released += unreleased;
        require(token.transfer(beneficiary, unreleased), "Token transfer failed");

        emit TokensReleased(beneficiary, unreleased);
    }

    function releasableAmount() public view returns (uint256) {
        return vestedAmount(uint256(block.timestamp)) - released;
    }

    function vestedAmount(uint256 _timestamp) public view returns (uint256) {
        uint256 currentBalance = token.balanceOf(address(this));
        uint256 totalBudget = currentBalance + released;

        if (_timestamp < cliff) {
            return 0;
        } else if (_timestamp >= start + duration) {
            return totalBudget;
        } else {
            return (totalBudget * (_timestamp - start)) / duration;
        }
    }
}
