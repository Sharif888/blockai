pragma solidity ^0.4.23;
pragma experimental ABIEncoderV2;

contract ModelRepository {
    address owner;
    Model[] models;
    Gradient[] grads;

    struct Gradient {
        bool evaluated;
        // submitted from miner
        address from;
        IPFS grads;
        uint modelId;
        // submitted from trainer
        uint newModelError;
        IPFS newWeights;
    }

    struct Model {
        string name;
        address owner;
        IPFS initialWeights;
        IPFS weights;
        uint bounty;
        uint initialError;
        uint bestError;
        uint targetError;
    }

    struct IPFS {
        string first;
        string second;
    }

    modifier onlyByModelOwner(uint gradientId) {
        require(msg.sender == models[grads[gradientId].modelId].owner, "You are not model owner!");
        _;
    }

    modifier onlyIfGradientNotYetEvaluated(uint gradientId) {
        require(grads[gradientId].evaluated == false, "Gradient evaluated already!");
        _;
    }

    function addModel(string name, uint initialError, uint targetError, string[] weights) public payable {

        IPFS memory ipfsWeights;
        ipfsWeights.first = weights[0];
        ipfsWeights.second = weights[1];

        Model memory newModel;
        newModel.name = name;
        newModel.weights = ipfsWeights;
        newModel.initialWeights = ipfsWeights;

        newModel.bounty = msg.value;
        newModel.owner = msg.sender;

        newModel.initialError = initialError;
        newModel.bestError = initialError;
        newModel.targetError = targetError;

        models.push(newModel);
    }

    function getModel(uint modelId) public view returns (string, address,uint,uint,uint,string[]) {
        Model memory currentModel;
        currentModel = models[modelId];
        string[] memory weights = new string[](2);

        weights[0] = currentModel.weights.first;
        weights[1] = currentModel.weights.second;

        return ( currentModel.name, currentModel.owner, 
        currentModel.bounty, currentModel.initialError, currentModel.targetError, weights);
    }

    function addGradient(uint modelId, string[] gradientAddress) public {
        require(models[modelId].owner != 0, "Invalid Model Owner");
        IPFS memory ipfsGradientAddress;
        ipfsGradientAddress.first = gradientAddress[0];
        ipfsGradientAddress.second = gradientAddress[1];

        IPFS memory newWeights;
        newWeights.first = "";
        newWeights.second = "";

        Gradient memory newGrad;
        newGrad.grads = ipfsGradientAddress;
        newGrad.from = msg.sender;
        newGrad.modelId = modelId;
        newGrad.newModelError = 0;
        newGrad.newWeights = newWeights;
        newGrad.evaluated = false;

        grads.push(newGrad);
    }

    function getNumGradientsforModel(uint modelId) public view returns (uint num) {
        num = 0;
        for (uint i = 0; i<grads.length; i++) {
            if (grads[i].modelId == modelId) {
                num += 1;
            }
        }
        return num;
    }

    constructor() public {
        owner = msg.sender;
    }
}