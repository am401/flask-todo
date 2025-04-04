# Intro
This repo relates to the following Udemy course: The course looks to have been originally published in 2021 and since then there has been much change on the AWS side of things. Previous work has been done on another application in this course: [github/am401/simple-flask](https://github.com/am401/simple-flask).

# Issues
Since this application is significantly more complicated I've identified numerous issues:

- The `amazon-linux-essentials` package manager is no longer necessary for AL2023 and beyond therefore this needs to be removed from the `userdata.sh` script - [source](https://docs.aws.amazon.com/linux/al2023/ug/epel.html)
- The `requirements.txt` file has a lot of outdated packages which are also running into multiple conflicts. This was ultimately a bit messy to fix but I have gone through and updated package versions where possible however got to the point that some of the versions continued to have conflicts with the newer versions. The final `requirements.txt` is added to this repo. The workaround I found was having to upgrade couple of Flask packages after the fact using:

```
pip install flask_wtf --upgrade
pip install flask_login --upgrade
```

- The `postgresql` package is somewhat outdates or no longer used to install this way. I found that the following works to install using `yum`:

```
yum install postgresql15.x86_64 postgresql15-server -y
```

- The `build-essential` package is no longer present. We can add `gcc-c++ make` to the `yum install gcc` command, which should cover the same - [source](https://serverfault.com/questions/204893/aws-ec2-and-build-essential)
- AWS CodeCommit is deprecated so using GitHub for the repo

# Changes
Most of the changes were done to the following:

- [x] Updated `scripts/userdata.sh` to remove the line installing the EPEL package
- [x] Updated `scripts/post_userdata` to include the `pip install` fixes for `flask_wtf` and `flask_login`
- [x] Replaced `git` URL for my repo
- [x] Updated `.env` file with the necessary variables

# Improvements
Improvements completed to the overall deployment process:

- [x] Added new variable `PSQL_PASSWORD` to the `.env` file
- [x] Created a new script `db_setup.sh` that can be executed on initial login
- [x] Setup the Terraform files for easier deployment

The original Udemy course used manual steps to setup the db where the course creator argued that since this was intended to only be run once there is no need to automate it or script it out. I disagree, we can create a script that can be executed on login, even if it's only done once.

This required finding ways to convert the commands from user input to a non-interactive version that can be run through the script. As always, StackOverflow and similar resources proved extremely helpful. With Terraform configured, I am down to the following process:

- Apply the terraform specifications
- Wait for EC2 to initialize
- SSH into the EC2
- Run the `scripts/db_setup.sh` file
