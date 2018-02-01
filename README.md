
## Missing features:
- Nginx stuff. Planning on making an easy to use, SSL enabling script to make Nginx easier to use. For now, if needed, here's the file from the old script: https://raw.githubusercontent.com/OriAlmogCode/UbuntuStartup/master/nginxconf
- Creating website. This should anyways be done in the home directory of the user that is created (/home/{username})

## Next steps:
Next step is creating some kind of python script for adding, managing, and removing SSL web addresses.
This script would be run in user mode, in the user dir, and will hopefully manage LetsEncrypt, Nginx settings, and everything else, as needed.
