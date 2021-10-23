const main = async () => {
  const gameContractFactory = await hre.ethers.getContractFactory("Game");
  const gameContract = await gameContractFactory.deploy(
    ["Devil Doggy", "Sleepy Cat", "Fairy Godmother Mouse"],
    [
      "https://www.fineartstorehouse.com/p/629/jack-russell-devil-dog-19654897.jpg.webp",
      "https://www.meme-arsenal.com/memes/1ff1e9812d9087a92f60cf4ae61202fd.jpg",
      "https://www.lonewolfforest.com/uploads/7/4/0/3/7403404/4595836_orig.jpg",
    ],
    [200, 100, 300],
    [50, 100, 30]
  );
  await gameContract.deployed();
  console.log("Contract deployed to:", gameContract.address);

  let txn;

  txn = await gameContract.mintNFT(2);
  await txn.wait();

  // Get the value of the NFT's URI.
  let returnedTokenUri = await gameContract.tokenURI(1);
  console.log("Token URI:", returnedTokenUri);
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();
