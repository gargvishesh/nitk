pragma solidity >=0.4.22 <0.6.0;
contract BGP {
    /// Track address of generals to prevent multiple votes
    address[] generals;
    uint8 registeredGenerals;
    
    enum ActionChoices {Retreat, Attack}
    /// Track votes against each general
    ActionChoices[] shallAttack;
    
    
    /// Create a new contract with total number of generals
    constructor(uint8 _numGenerals) public {
        registeredGenerals = 0;
        generals.length = _numGenerals;
        shallAttack.length = _numGenerals;
    }

    function attack() public{
        for (uint8 id = 0; id < registeredGenerals; id++){
            if (msg.sender == generals[id]){
                return;
            }
        }
        generals[registeredGenerals] = msg.sender;
        shallAttack[registeredGenerals] = ActionChoices.Attack;
        registeredGenerals = registeredGenerals + 1;
    }
    
    function retreat() public {
        for (uint8 id = 0; id < registeredGenerals; id++){
            if (msg.sender == generals[id]){
                return;
            }
        }
        generals[registeredGenerals] = msg.sender;
        shallAttack[registeredGenerals] = ActionChoices.Retreat;
        registeredGenerals = registeredGenerals + 1;
    }
    
    function checkConsensus() public view returns (string memory consensus) {
        if (registeredGenerals < generals.length){
            consensus = "NoConsensus";
        } 
        else {
            uint sumShallAttack = 0;
            for (uint8 id = 0; id < registeredGenerals; id++){
                sumShallAttack = sumShallAttack + uint8(shallAttack[id]);
            }
            if (2 * sumShallAttack > generals.length * uint8(ActionChoices.Attack)){
                consensus = "Attack";
            }
            else{
                consensus = "Retreat";
            }    
        }
        return consensus;
    }

    function resetVotes() public{
        registeredGenerals = 0;
    }

    function getVoters() public view returns (address [] memory){
        return generals;
    }

    function getVotesCount() public view returns (uint8){
        return registeredGenerals;
    }
}
