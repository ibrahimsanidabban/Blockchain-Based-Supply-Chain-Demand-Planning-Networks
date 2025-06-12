# Blockchain-Based Supply Chain Demand Planning Networks

A comprehensive blockchain solution for managing supply chain demand planning through smart contracts built on the Stacks blockchain using Clarity.

## Overview

This system provides a decentralized platform for supply chain demand planning that includes:

- **Demand Planner Verification**: Validates and manages supply chain demand planners
- **Forecasting Algorithm Management**: Manages demand forecasting algorithms and their execution
- **Collaboration Platform**: Facilitates demand planning collaboration between planners
- **Accuracy Measurement**: Measures and tracks forecasting accuracy
- **Plan Optimization**: Optimizes demand plans based on various parameters

## Smart Contracts

### 1. Demand Planner Verification (`demand-planner-verification.clar`)

Manages the registration, verification, and tracking of demand planners.

**Key Features:**
- Planner registration with certification levels
- Owner-controlled verification process
- Accuracy score tracking
- Status management (pending/verified)

**Main Functions:**
- \`register-planner\`: Register a new demand planner
- \`verify-planner\`: Verify a planner (owner only)
- \`update-accuracy-score\`: Update planner's accuracy score
- \`get-planner\`: Retrieve planner information

### 2. Forecasting Algorithm (`forecasting-algorithm.clar`)

Handles the creation, execution, and management of demand forecasting algorithms.

**Key Features:**
- Algorithm creation and registration
- Forecast execution with confidence levels
- Usage tracking and accuracy rating
- Result storage and retrieval

**Main Functions:**
- \`create-algorithm\`: Create a new forecasting algorithm
- \`execute-forecast\`: Execute a forecast using an algorithm
- \`update-algorithm-accuracy\`: Update algorithm accuracy rating
- \`get-algorithm\`: Retrieve algorithm details

### 3. Collaboration Platform (`collaboration-platform.clar`)

Enables collaborative demand planning projects between multiple planners.

**Key Features:**
- Project creation and management
- Participant management with roles
- Project updates and communication
- Status tracking and deadlines

**Main Functions:**
- \`create-project\`: Create a new collaboration project
- \`join-project\`: Join an existing project
- \`add-project-update\`: Add updates to a project
- \`get-project\`: Retrieve project details

### 4. Accuracy Measurement (`accuracy-measurement.clar`)

Measures and tracks the accuracy of demand forecasts.

**Key Features:**
- Accuracy measurement recording
- Statistical tracking for planners and algorithms
- Performance analytics
- Historical accuracy data

**Main Functions:**
- \`record-accuracy-measurement\`: Record a new accuracy measurement
- \`get-planner-accuracy-stats\`: Get planner accuracy statistics
- \`get-algorithm-accuracy-stats\`: Get algorithm accuracy statistics

### 5. Plan Optimization (`plan-optimization.clar`)

Optimizes demand plans based on various parameters and constraints.

**Key Features:**
- Optimization plan creation
- Parameter management with weights
- Optimization execution
- Result analysis and recommendations

**Main Functions:**
- \`create-optimization-plan\`: Create a new optimization plan
- \`add-optimization-parameter\`: Add optimization parameters
- \`execute-optimization\`: Execute plan optimization
- \`get-optimization-result\`: Retrieve optimization results

## Installation

1. Clone the repository
2. Install Clarinet (Stacks development tool)
3. Run tests using Vitest

\`\`\`bash
# Install dependencies
npm install

# Run tests
npm test

# Deploy contracts (using Clarinet)
clarinet deploy
\`\`\`

## Usage

### Registering as a Demand Planner

\`\`\`clarity
(contract-call? .demand-planner-verification register-planner "John Doe" u3)
\`\`\`

### Creating a Forecasting Algorithm

\`\`\`clarity
(contract-call? .forecasting-algorithm create-algorithm
"Linear Regression"
"regression"
"window=30,trend=linear")
\`\`\`

### Starting a Collaboration Project

\`\`\`clarity
(contract-call? .collaboration-platform create-project
"Q4 Planning"
"Collaborative Q4 demand planning"
u1000)
\`\`\`

### Recording Forecast Accuracy

\`\`\`clarity
(contract-call? .accuracy-measurement record-accuracy-measurement
u1 u1 u1 u1000 u950 "monthly")
\`\`\`

### Creating an Optimization Plan

\`\`\`clarity
(contract-call? .plan-optimization create-optimization-plan
u1
"Q4 Optimization"
u10000
"seasonality,inventory")
\`\`\`

## Testing

The project includes comprehensive tests for all contracts using Vitest:

\`\`\`bash
npm test
\`\`\`

Tests cover:
- Contract functionality
- Error handling
- Edge cases
- Data validation
- Access control

## Architecture

The system follows a modular architecture where each contract handles a specific aspect of demand planning:

1. **Identity Layer**: Demand planner verification
2. **Algorithm Layer**: Forecasting algorithm management
3. **Collaboration Layer**: Multi-planner project coordination
4. **Analytics Layer**: Accuracy measurement and tracking
5. **Optimization Layer**: Plan optimization and improvement

## Security Features

- Owner-controlled verification processes
- Access control for sensitive operations
- Input validation and error handling
- Immutable audit trail of all operations
- Decentralized data storage

## Future Enhancements

- Integration with external data sources
- Advanced optimization algorithms
- Real-time collaboration features
- Mobile application interface
- Integration with existing ERP systems

## Contributing

1. Fork the repository
2. Create a feature branch
3. Add tests for new functionality
4. Ensure all tests pass
5. Submit a pull request

## License

This project is licensed under the MIT License.
