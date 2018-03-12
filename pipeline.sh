buildAndBump() {
  LAST_COMMIT_MESSAGE=$(git log -1 --pretty=%B | tr -d '\n')
  if [[ "${LAST_COMMIT_MESSAGE}" == "${CD_COMMIT_MESSAGE}" ]];
  then
      echo "Skipping build"
  else
    gradle clean build
    ./pipelineUtils.sh setProperty version $(./pipelineUtils.sh incrementVersion -p $(./pipelineUtils.sh getProperty version gradle.properties)) gradle.properties
    git add gradle.properties
    git commit -m "$CD_COMMIT_MESSAGE"
    git push https://$GITHUB_USER:$GITHUB_TOKEN@github.com/dermotmburke/hello-boot.git master
  fi

}

"$@"