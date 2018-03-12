setUpGit() {
  git config --local user.name "Travis CI"
  git config --local user.email "builds@travis-ci.com"
}

buildAndBump() {
  gradle clean build
  if [[ "${LAST_COMMIT_MESSAGE}" == "${CD_COMMIT_MESSAGE}" ]];
  then
      echo "Skipping version bump"
  else
    if [[ $TRAVIS_BRANCH == 'master' ]]
    then
      setUpGit
      git checkout master
      ./pipelineUtils.sh setProperty version $(./pipelineUtils.sh incrementVersion -p $(./pipelineUtils.sh getProperty version gradle.properties)) gradle.properties
      git add gradle.properties
      git commit -m "$CD_COMMIT_MESSAGE"
      git push https://$GITHUB_USER:$GITHUB_TOKEN@github.com/dermotmburke/hello-boot.git master
    fi
  fi
}

prepareDeploy() {
  setUpGit
  git tag "$TRAVIS_TAG"
  mv build/publications/mavenJava/pom-default.xml build/publications/mavenJava/pom.xml
}

"$@"