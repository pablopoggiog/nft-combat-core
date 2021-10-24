const main = async () => {
  const gameContractFactory = await hre.ethers.getContractFactory("Game");
  const gameContract = await gameContractFactory.deploy(
    ["Evil Doggy", "Sleepy Cat", "Fairy Godmother Mouse"],
    [
      "https://www.fineartstorehouse.com/p/629/jack-russell-devil-dog-19654897.jpg.webp",
      "https://www.meme-arsenal.com/memes/1ff1e9812d9087a92f60cf4ae61202fd.jpg",
      "https://www.lonewolfforest.com/uploads/7/4/0/3/7403404/4595836_orig.jpg",
    ],
    [200, 100, 300],
    [50, 100, 30],
    "Bearish Birdie",
    "https://i.ytimg.com/vi/ghnloXl4Jx4/maxresdefault.jpg",
    10000,
    50
  );
  await gameContract.deployed();
  console.log("Contract deployed to:", gameContract.address);
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
