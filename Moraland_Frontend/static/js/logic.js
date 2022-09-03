
//Initializing constants
const serverUrl = "https://ljgiacaiuzaf.usemoralis.com:2053/server";
const appId = "6CU1DIgbkjrck51m2HCB8WB5ymwcgAxEk795qXWS";
const ethers = Moralis.web3Library;


//=======================================================================================================================================-
//variables and dummy dataset
//========================================================================================================================================
let plotView =["void.snows.lobbingsight","faulting.akin.launchers","bumpkins.meeting.slalom","void.snows.lobbing","dilating.reciprocal.suitably"]
let hashStore=[]    // an array that would store the hashed string of the  concatenated words for each tile with dots included
let HashedArrAsString;   /// a string that represents all the hashes form every single tile,concatenated
let plotID;               // will hold the master hash as a value;
let incrementer =0;
let nftObject;            //the metadata object
let cIdOfUploadeedPhoto; // variable that stores the cid of the uploaded image by the user


//=======================================================================================================================================
//HTML Selectors
//=======================================================================================================================================-
let $render=document.getElementById("render");   // not improtant 
let $plotID=document.getElementById("plotID");   // not important
let $ipfs=document.getElementById("ipfs");   // not important
let $uploadImageToIPFS=document.getElementById('uploadImageToIPFS'); //not important
let $uploadValue=document.getElementById('upload'); //not important

 
//UI Functions
function setPlotData() {
    console.log(plotView);                      // displaying the initial words array
    for (let i=0; i<plotView.length; i++){      //loop that invokes a keccak hash on every element in the tiles' words array
      let hash = ethers.utils.id((plotView[i]));
      hashStore.push(hash);                     // push the resulting hash into the hashstore array
    }

    HashedArrAsString=hashStore.join("");                  // i convert the entira hasstore array to a single string
     plotID = ethers.utils.id(HashedArrAsString);          // i pass this string to the hashing function again
    console.log(plotID);
    nftObject = Object.assign({},hashStore);             //initialising an object that would contain the hashes of all claimed tiles , as well as their masterhash
    nftObject.masterHash=plotID;                          //add the masterhash to the metadata 
    console.log(nftObject);
    $plotID.value=plotID;
   

    /// code below not important 
   plotView.map(tileWords=>$render.innerHTML+=`<span> Tile ${incrementer++} coordinates<input disabled="true" id=${incrementer} type="text" class="form-control" value=${tileWords}><p></p>`);

}

//========================================================================================================================================
//IPFS functionality
//========================================================================================================================================

//1 Uploading the image to IPFS
async function upload () {
const data = $uploadValue.files[0];
const file = new Moralis.File(data.name, data);
await file.saveIPFS();
 cIdOfUploadeedPhoto = file.ipfs();
 nftObject.imageURI=cIdOfUploadeedPhoto;
 $ipfs.removeAttribute('disabled');
console.log("Image saved to IPFS at: " + cIdOfUploadeedPhoto);
}

$uploadImageToIPFS.addEventListener('click',upload);


//upload the Image and the other metadata to IPFS


async function uploadToIpfs () {
    const metadata = new Moralis.File("metadata.json", {
        base64: btoa(JSON.stringify(nftObject)),
      });
      await metadata.saveIPFS();
      console.log(metadata.hash());
      console.log(`Link to the file on IPFS:   ${metadata.ipfs()}`);                     //check the console for the ipfs link
}

$ipfs.addEventListener('click',uploadToIpfs);

















//========================================================================================================================================
//web3 Functions
async function login(){
    Moralis.Web3.authenticate().then(async function (){
        const chainIdHex = await Moralis.switchNetwork("0x13881");
    });
}

/* *async function assignPlot() {
    const plotID = document.getElementById("plotID").value;
    const assigned = await isPlotAssigned(plotID);
    if (!assigned) {
        const metadata = {
            "PlotID":plotID,
            "PlotX":document.getElementById("plotX").value,
            "PlotY":document.getElementById("plotY").value,
            "LocationX":document.getElementById("locationX").value,
            "LocationY":document.getElementById("locationX").value,
            "image":"https://moralis.io/wp-content/uploads/2021/06/Moralis-Glass-Favicon.svg",
        }
        const metadataFile = new Moralis.File("metadata.json", {base64 : btoa(JSON.stringify(metadata))});
        await metadataFile.saveIPFS();
        const metadataURI = metadataFile.ipfs();
        await mint(metadataURI);
    }
    else{
        displayMessage("01","Plot is already assigned");
    }
}


async function mint(_tokenURI) {
    const contractOptions = {
        contractAddress: contractAddress,
        abi: contractABI,
        functionName: "assign",
        params: {
            tokenURI:_tokenURI,
            bytesId:document.getElementById("plotID").value
        }
    }
    try{
        const transaction = await Moralis.executeFunction(contractOptions);
        await transaction.wait();
        displayMessage("00","Transaction confirmed with hash "+transaction.hash);
    }
    catch(error){
        displayMessage("01","Transaction reverted see console for details");
        console.log(error)
    }
}


async function isPlotAssigned(plotID) {
    const contractOptions = {
        contractAddress: contractAddress,
        abi: contractABI,
        functionName: "exist",
        params: {
            bytesId:plotID
        }
    }
    return await Moralis.executeFunction(contractOptions);
}

*/

Moralis.start({ serverUrl, appId }); 
login(); 
setPlotData();
//drawCanvas();
//window.addEventListener('keydown' , (e) => {
 //   move(e.key)
//});
