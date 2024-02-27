import { ethers } from "hardhat";

async function main() {
   const factory = await ethers.deployContract("Factory");

  await factory.waitForDeployment();

  console.log(
    `Factory Contract  deployed to ${factory.target}`
  );

  const socialMedia = await ethers.deployContract("SocialMediaPlatform");

  await socialMedia.waitForDeployment();

  console.log(
    `Social Media Platform Contract  deployed to ${socialMedia.target}`
  );


}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
