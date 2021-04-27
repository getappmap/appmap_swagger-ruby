# Configuration variables:

* `GH_TOKEN`: used by `semantic-release` to push changes to Github and manage releases
* `GEM_HOST_API_KEY`: rubygems API key
* `GEM_ALTERNATIVE_NAME` (optional): used for testing of CI flows, 
to avoid publication of test releases under official package name

# Release command

`./release.sh` 

Bash wrapper script is used merely as a launcher of `semantic-release` 
with extra logic to explicitly determine git url from `TRAVIS_REPO_SLUG` \
variable if its defined 

# CI flow

1. The version number is increased (including modicication of `lib/appmap/swagger/version.rb`)
2. Gem is published under new version number
3. Github release is created with the new version number
