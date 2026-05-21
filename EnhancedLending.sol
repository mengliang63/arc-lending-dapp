// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20 {
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
    function transfer(address to, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

interface IPriceOracle {
    function getPrice(address asset) external view returns (uint256);
}

contract EnhancedLending {
    IPriceOracle public oracle;
    
    uint256 public constant LIQUIDATION_THRESHOLD = 80;
    uint256 public constant LIQUIDATION_BONUS = 10;
    uint256 public constant CLOSE_FACTOR = 50;
    
    address public owner;
    address public borrowToken;
    
    mapping(address => bool) public supportedCollateral;
    mapping(address => mapping(address => uint256)) public collateral; // user => token => amount
    mapping(address => uint256) public debt;
    
    uint256 public totalBorrow;
    uint256 public lastUpdateTime;
    uint256 public borrowIndex = 1e18;
    uint256 public supplyIndex = 1e18;
    
    mapping(address => mapping(address => uint256)) public userSupplyIndex;
    
    event Deposit(address indexed user, address indexed token, uint256 amount);
    event Withdraw(address indexed user, address indexed token, uint256 amount);
    event Borrow(address indexed user, uint256 amount);
    event Repay(address indexed user, uint256 amount);
    event ClaimInterest(address indexed user, uint256 interest);
    
    modifier onlyOwner() { 
        require(msg.sender == owner, "Not owner"); 
        _; 
    }
    
    constructor(address _oracle, address _borrowToken) {
        owner = msg.sender;
        oracle = IPriceOracle(_oracle);
        borrowToken = _borrowToken;
        lastUpdateTime = block.timestamp;
    }
    
    // ==================== 添加支持的抵押品 ====================
    function addSupportedCollateral(address token) external onlyOwner {
        supportedCollateral[token] = true;
    }
    
    function _updateInterest() internal {
        if (totalBorrow == 0) {
            lastUpdateTime = block.timestamp;
            return;
        }
        
        uint256 timeDelta = block.timestamp - lastUpdateTime;
        if (timeDelta == 0) return;
        
        uint256 utilization = (totalBorrow * 1e18) / (totalBorrow + 1e18);
        
        uint256 baseRatePerYear = 2e16;      // 2%
        uint256 slopeRatePerYear = 20e16;    // 20%
        
        uint256 borrowRatePerYear = baseRatePerYear + (slopeRatePerYear * utilization / 1e18);
        uint256 borrowRatePerSecond = borrowRatePerYear / 365 days;
        
        uint256 interest = totalBorrow * borrowRatePerSecond * timeDelta / 1e18;
        
        totalBorrow += interest;
        borrowIndex = borrowIndex * (1e18 + borrowRatePerSecond * timeDelta) / 1e18;
        supplyIndex = supplyIndex * (1e18 + (borrowRatePerSecond * timeDelta * 90 / 100)) / 1e18;
        
        lastUpdateTime = block.timestamp;
    }
    
    function deposit(address token, uint256 amount) external {
        require(supportedCollateral[token], "Unsupported collateral");
        _updateInterest();
        require(amount > 0, "Amount > 0");
        
        IERC20(token).transferFrom(msg.sender, address(this), amount);
        collateral[msg.sender][token] += amount;
        userSupplyIndex[msg.sender][token] = supplyIndex;
        
        emit Deposit(msg.sender, token, amount);
    }
    
    function withdraw(address token, uint256 amount) external {
        _updateInterest();
        require(collateral[msg.sender][token] >= amount, "Insufficient collateral");
        require(getHealthFactor(msg.sender) >= 1e18, "Health factor too low");
        
        collateral[msg.sender][token] -= amount;
        IERC20(token).transfer(msg.sender, amount);
        emit Withdraw(msg.sender, token, amount);
    }
    
    function borrow(uint256 amount) external {
        _updateInterest();
        require(getHealthFactor(msg.sender) >= 1e18, "Health factor too low");
        require(amount > 0, "Amount > 0");
        
        debt[msg.sender] += amount;
        totalBorrow += amount;
        IERC20(borrowToken).transfer(msg.sender, amount);
        emit Borrow(msg.sender, amount);
    }
    
    function repay(uint256 amount) external {
        _updateInterest();
        require(debt[msg.sender] >= amount, "Repay too much");
        IERC20(borrowToken).transferFrom(msg.sender, address(this), amount);
        debt[msg.sender] -= amount;
        totalBorrow -= amount;
        emit Repay(msg.sender, amount);
    }
    
    function claimInterest(address token) external {
        _updateInterest();
        uint256 userIndex = userSupplyIndex[msg.sender][token];
        if (userIndex == 0) return;
        
        uint256 coll = collateral[msg.sender][token];
        uint256 interest = coll * (supplyIndex - userIndex) / 1e18;
        
        if (interest > 0) {
            IERC20(token).transfer(msg.sender, interest);
            userSupplyIndex[msg.sender][token] = supplyIndex;
            emit ClaimInterest(msg.sender, interest);
        }
    }
    
    function getHealthFactor(address user) public view returns (uint256) {
        uint256 debtValue = debt[user] * oracle.getPrice(borrowToken) / 1e8;
        if (debtValue == 0) return type(uint256).max;
        uint256 totalCollValue = 0; // 简化版，实际生产需累加所有抵押品价值
        return (totalCollValue * LIQUIDATION_THRESHOLD * 1e18) / (debtValue * 100);
    }
    
    function getCurrentBorrowAPY() external pure returns (uint256) {
        uint256 utilization = 50 * 1e16;
        uint256 baseRatePerYear = 2e16;
        uint256 slopeRatePerYear = 20e16;
        uint256 borrowRatePerYear = baseRatePerYear + (slopeRatePerYear * utilization / 1e18);
        return borrowRatePerYear / 1e14; // 如 1220 表示 12.20%
    }
    
    function getUserInfo(address user, address token) external view returns (
        uint256 collAmount,
        uint256 debtAmount,
        uint256 pendingInterest,
        uint256 healthFactor
    ) {
        collAmount = collateral[user][token];
        debtAmount = debt[user];
        pendingInterest = collAmount * (supplyIndex - userSupplyIndex[user][token]) / 1e18;
        healthFactor = getHealthFactor(user);
    }
    
    function setOracle(address newOracle) external onlyOwner {
        oracle = IPriceOracle(newOracle);
    }
}