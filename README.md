Arc Testnet Simple Lending DAppA simple lending protocol built on the Arc Network, developed in Solidity. It supports collateralization, borrowing, repayment, automatic interest accrual, and more.The project uses the simplest deployment method with Remix + MetaMask, making it ideal for learning and quick demonstrations. Project InformationNetwork: Arc Testnet  
Borrow Asset: USDC (0x3600000000000000000000000000000000000000)  
Collateral Asset: WETH (0x4200000000000000000000000000000000000006)

Deployed Contract Addresses:Contract
Address
EnhancedLending
0x313CeBB29eD02AdF31cA15520a9cACa9f1956cd5
MockOracle
0x84a8563dECad0f5E1e56C8A635A86DcEf9C17C12

 Key FeaturesMulti-collateral support (currently supports WETH)
Real-time interest rate model (Utilization-based)
Automatic interest accrual on deposits (claimable anytime)
Borrow & Repay functionality
Health Factor monitoring
Basic liquidation mechanism
Complete single-page web frontend for easy interaction

 Project Structurebash

arc-lending-dapp/
├── contracts/
│   ├── EnhancedLending.sol          # Main lending contract
│   └── MockOracle.sol               # Mock price oracle for testing
├── frontend/
│   └── index.html                   # Single-file frontend DApp
├── README.md
└── .gitignore


