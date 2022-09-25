//Initializing constants
const serverUrl = "https://bcckkboiuxaw.usemoralis.com:2053/server";
const appId = "S5DBNsYW0Upw8HXkov87GdviW63eMVUCRFRl2Jue";
Moralis.start({ serverUrl, appId });
const ethers = Moralis.web3Library;

//=======================================================================================================================================-
//variables and dummy dataset
//========================================================================================================================================
let plotView = [
  "void.snows.lobbingsight",
  "faulting.akin.launchers",
  "bumpkins.meeting.slalom",
  "void.snows.lobbing",
  "dilating.reciprocal.suitably",
];
let hashStore = []; // an array that would store the hashed string of the  concatenated words for each tile with dots included
let HashedArrAsString; /// a string that represents all the hashes form every single tile,concatenated
let plotID; // will hold the master hash as a value;
let incrementer = 0;
let nftObject; //the metadata object
let cIdOfUploadeedPhoto; // variable that stores the cid of the uploaded image by the user

//=======================================================================================================================================
//HTML Selectors
//=======================================================================================================================================-
let $render = document.getElementById("render"); // not improtant
let $plotID = document.getElementById("plotID"); // not important
let $ipfs = document.getElementById("ipfs"); // not important
let $uploadImageToIPFS = document.getElementById("uploadImageToIPFS"); //not important
let $uploadValue = document.getElementById("upload"); //not important
let $plotSize = document.getElementById("plotSize"); //not important
let $userAddress = document.getElementById("userAddress"); //not important
let $swap = document.getElementById("swap"); //not important
let $amount = document.getElementById("amount"); //not important

//========================================================================================================================================
//Displaying the current wallet address
//========================================================================================================================================
async function displayUser() {
  let wallet = await Moralis.User.currentAsync();
  let user = await wallet.get("ethAddress");
  $userAddress.innerHTML = user;
  console.log(user);
}

//========================================================================================================================================
//web3 Functions
//========================================================================================================================================
async function login() {
  Moralis.Web3.authenticate().then(async function () {
    const chainIdHex = await Moralis.switchNetwork("0x5");
  });
}

async function Swapp() {
  const ABI = [
    {
      anonymous: false,
      inputs: [
        {
          indexed: true,
          internalType: "address",
          name: "owner",
          type: "address",
        },
        {
          indexed: true,
          internalType: "address",
          name: "spender",
          type: "address",
        },
        {
          indexed: false,
          internalType: "uint256",
          name: "value",
          type: "uint256",
        },
      ],
      name: "Approval",
      type: "event",
    },
    {
      anonymous: false,
      inputs: [
        {
          indexed: true,
          internalType: "address",
          name: "from",
          type: "address",
        },
        {
          indexed: true,
          internalType: "uint256",
          name: "amount",
          type: "uint256",
        },
      ],
      name: "depositDone",
      type: "event",
    },
    { stateMutability: "payable", type: "fallback" },
    {
      inputs: [{ internalType: "address", name: "", type: "address" }],
      name: "_ethbalances",
      outputs: [{ internalType: "uint256", name: "", type: "uint256" }],
      stateMutability: "view",
      type: "function",
    },
    {
      inputs: [{ internalType: "uint256", name: "amountIn", type: "uint256" }],
      name: "swap",
      outputs: [{ internalType: "uint256", name: "", type: "uint256" }],
      stateMutability: "nonpayable",
      type: "function",
    },
    { stateMutability: "payable", type: "receive" },
  ];
  const swapp = {
    contractAddress: "0xad1a76ffbf12d45c23fd9d1f1e073d05ce9bde39",
    functionName: "swap",
    abi: ABI,
    params: {
      amountIn: amount.value,
    },
  };
  try {
    await Moralis.executeFunction(swapp);
    console.log("Starting mint process");
  } catch (error) {
    console.log(error);
  }
}

document.getElementById("swap").onclick = Swapp;

//========================================================================================================================================
//functions to be executed upon load
//========================================================================================================================================
login();
displayUser();
