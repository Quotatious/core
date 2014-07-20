# Deploy

Run in a terminal:
```
cap <server_name> deploy
```
Where ```<server_name>``` is the name of the stage (e.g. staging, production ...)

To deploy a specific branch please use BRANCH_NAME variable:
```
BRANCH_NAME=my-branch cap <server_name> deploy
```