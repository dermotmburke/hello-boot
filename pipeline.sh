setUp() {
  git config --local user.name "Travis CI"
  git config --local user.email "builds@travis-ci.com"
}

buildAndBump() {
  setUp
  LAST_COMMIT_MESSAGE=$(git log -1 --pretty=%B | tr -d '\n')
  if [[ "${LAST_COMMIT_MESSAGE}" == "${CD_COMMIT_MESSAGE}" ]];
  then
      echo "Skipping build"
  else
    git checkout master
    gradle clean build
    ./pipelineUtils.sh setProperty version $(./pipelineUtils.sh incrementVersion -p $(./pipelineUtils.sh getProperty version gradle.properties)) gradle.properties
    git add gradle.properties
    git commit -m "$CD_COMMIT_MESSAGE"
    git push https://$GITHUB_USER:$GITHUB_TOKEN@github.com/dermotmburke/hello-boot.git master
  fi

}

prepareDeploy() {
  setUp
  export RELEASE_FILE=build/libs/hello-boot-$TRAVIS_TAG.jar
  git tag "$TRAVIS_TAG"
  mv build/publications/mavenJava/pom-default.xml build/publications/mavenJava/pom.xml
}

"$@"