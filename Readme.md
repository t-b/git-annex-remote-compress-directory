Special remote for [git annex](https://git-annex.branchable.com) doing compression with zstd before storing the files in a folder.

Installation:
- chmod a+x git-annex-remote-compress-directory
- sudo cp git-annex-remote-compress-directory /usr/local/bin

Usage:
- git -c init.templatedir init
- git annex init
- git annex initremote myremote type=external encryption=none externaltype=compress-directory directory="someFolder"
