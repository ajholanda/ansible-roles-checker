# Ansible roles checker

This project contains Vagrant configuration to create boxes to check some 
Ansible roles I've created.

- To create the boxes:

```
$ vagrant up
```

Connect in any Linux box and run the ansible, for example:

```
vagrant ssh ubuntu # password: vagrant
cd ansible
./check.sh
```

---
[Adriano J. Holanda](https://ajholanda.github.io)