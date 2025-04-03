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
I'm currently working on creating a script to automatically setup the database. I was able to figure out most of the database commands to be run through a shell script, however this remains a todo task. The high level concept is:

```
su postgres -c "pg_ctl init -D /var/lib/pgsql/data"
systemctl start postgresql
systemctl enable postgresql
su postgres -c "psql -c \"CREATE USER flasktodo WITH PASSWORD '[password]'\""
su postgres -c 'createdb -e --owner=flasktodo todos'
export FLASK_APP=wsgi
systemctl restart flasktodo
systemctl restart nginx
flask db upgrade
```

I'm considering add the password for the above to the `.env` file as a `PSQL_PASSWORD` variable.

Aside from the above, I will be configuring this to run with Terraform too so will be adding that in once the overall database setup and configuration is finalized.
