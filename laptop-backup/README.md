# Laptop backup

Everyone should backup. So far, I have an external HDD, pluged in into dockstation and I want to backup my personal files to this drive.
Here are the requirements:

* backup should be done automatically and report via log / mail status of backups (fail and success)
* external HDD should be mounted only when necessary - safely mount before backup and umount after backup.
* backup should be encrypted and incremental (I will try duplicity for this)
* there should be an easy way to extend backup script to save files in network / cloud storage (duplicity will do this)
* secrets will be accesible for scripts but in a safe storage - no plain text! (maybe Hashicorp's Vault will help me / access to KeePass?)
* there must be a way to test the backups. Files will be periodically restored and checked for integrity every two weeks.
* script should be portable. In case of disaster and booting into new system I want an effortless restoration option. The requirements for scripts should be easily installed repeatedly (Ansible playbook?)
