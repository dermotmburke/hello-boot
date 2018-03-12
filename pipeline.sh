setUpGit() {
  git config --local user.name "Travis CI"
  git config --local user.email "builds@travis-ci.com"
}

build() {
  if [[ "${LAST_COMMIT_MESSAGE}" == "${CD_COMMIT_MESSAGE}" ]];
  then
    echo "Skipping build"
  else
    gradle clean build
    if [[ $TRAVIS_BRANCH != 'master' ]];
      then
        echo "Skipping bump"
      else
        setUpGit
        git checkout master
        ./pipelineUtils.sh setProperty version $(./pipelineUtils.sh incrementVersion -p $(./pipelineUtils.sh getProperty version gradle.properties)) gradle.properties
        git add gradle.properties
        git commit -m "$CD_COMMIT_MESSAGE"
        git push https://$GITHUB_USER:$GITHUB_TOKEN@github.com/$TRAVIS_REPO_SLUG master
      fi
   fi
}

prepareDeploy() {
  if [[ "${LAST_COMMIT_MESSAGE}" == "${CD_COMMIT_MESSAGE}" ]];
  then
    echo "Skipping prepareDeploy"
  else
    setUpGit
    git tag "$TRAVIS_TAG"
    mv build/publications/mavenJava/pom-default.xml build/publications/mavenJava/pom.xml 2>/dev/null
  fi
}

"$@"