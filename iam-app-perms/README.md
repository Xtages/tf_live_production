# iam-app-perms

IAM Permissions given to customer's applications.
This is used through the task definition in [Recipe](git@github.com:Xtages/recipes.git) repository

Originally thought in add it as a module in Recipe and reference it here, however when Terraform tries to download the 
module code ask for the credentials and to avoid that issue we have to do something like [this](https://git-scm.com/book/en/v2/Git-Tools-Credential-Storage). Terraform documentation about that can be seen [here](https://www.terraform.io/docs/language/modules/sources.html#generic-git-repository)
