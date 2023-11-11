# Open Science repository for NORMENT

This repository stores data and scripts associated with NORMENT publications.

This repository is connected to GitHub's Large File Storage (LFS) system so it is not limited by conventional storage restraints.

In order to download a particular folder to your local machine, you can use this command:

```bash
svn export https://github.com/norment/open-science/trunk/<folder>
```

E.g. `svn export https://github.com/norment/open-science/trunk/2021_Roelfs_TranslPsych_MentalHealth_ICA_GWAS` will download the entire folder with data and code related to that publication only.

Currently, the `svn` method **doesn't** automatically download the files in the LFS-storage. When there's a command line method to download LFS files, it'll be added here. Until then, you can download the files in LFS manually via the website.

## Uploading data

NORMENT employees wanting to share their data and code can look up the instructions on the internal wiki. Contact any of the contributors to this repository for further info.
