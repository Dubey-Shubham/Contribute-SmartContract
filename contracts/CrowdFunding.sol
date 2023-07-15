// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract CrowdFunding {
    //object will contain varible, array etc that we require in smart contract creation
    struct Campaign {                    //struct is like a object in sol
        address owner;
        string title;                    //its a static language so we have to mention datatype
        string description;
        uint256 target;                  // its just a number
        uint256 deadline;
        uint256 amountCollected;
        string image;                    //url hoga thats why string
        address[] donators;              //multiple donators honge thats why array
        uint256[] donations;
    }

    mapping(uint256 => Campaign) public campaigns;

    uint256 public numberOfCampaigns = 0;            //initially campaigns are 0, we are tracking them so we can track their ids
// function to create new campaign
    function createCampaign(address _owner, string memory _title, string memory _description, uint256 _target, uint256 _deadline, string memory _image) public returns (uint256) {  //parameter its going to take in, its public means we can access it from frontend and it will return a id so 256
        Campaign storage campaign = campaigns[numberOfCampaigns];     //jab bhi new campaign banega total campaign increment ho jayenge

        require(campaign.deadline < block.timestamp, "The deadline should be a date in the future.");    // require is like a check that need to happen for code to proceed(yahan we are checking that deadline should be in future)

        campaign.owner = _owner;
        campaign.title = _title;
        campaign.description = _description;
        campaign.target = _target;
        campaign.deadline = _deadline;
        campaign.amountCollected = 0;         //at start
        campaign.image = _image;

        numberOfCampaigns++;                  //total campaign increment ho jayega

        return numberOfCampaigns - 1;         //it will be index of newly created campaign
    }
// function to donate to a particular campaign
    function donateToCampaign(uint256 _id) public payable {  //it will take id it will be public and this function will involve some cryptocurrency that why it is payable
        uint256 amount = msg.value;          //it will be sent from the frontend

        Campaign storage campaign = campaigns[_id];       //campaign jisko donate karenge

        campaign.donators.push(msg.sender);             // we want to push the address of the donator
        campaign.donations.push(amount);                // amount will also be pushed 

        (bool sent,) = payable(campaign.owner).call{value: amount}("");         //sent is a bool variable that will let us know whether transaction is sent or not, owner se amount add karwayenge yahan

        if(sent) {
            campaign.amountCollected = campaign.amountCollected + amount;       //total amount collected me amount jo user ne add kiya wo increment kar diya
        }
    }
//this will give us a list of all the people who donated
    function getDonators(uint256 _id) view public returns (address[] memory, uint256[] memory) {     // here we took id(jis campaign k donaters ki detail deni hai us ki id), its view, matlab user dekh skta hai, public bhi hai ye, aur ye return array of donators and donation karega
        return (campaigns[_id].donators, campaigns[_id].donations);      //campaign id k corresponding donators aur donations ka array return kar dia 
    }
//to get list of all campaigns  
    function getCampaigns() public view returns (Campaign[] memory) {    //takes nothing, its view and public and will return array of campaign from memory
        Campaign[] memory allCampaigns = new Campaign[](numberOfCampaigns);    // here we created a new array variable called allcampaign and created empty array of size equal to total no of campaigns

        for(uint i = 0; i < numberOfCampaigns; i++) {
            Campaign storage item = campaigns[i];         // storage se index first campaign liya

            allCampaigns[i] = item;                       // aur fetched campaign ko  all campaihn array me de diya
        }

        return allCampaigns;             //array ko return kar diya
    }
}                