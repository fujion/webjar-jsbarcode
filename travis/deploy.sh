#!/usr/bin/env bash

if [[ "$TRAVIS_PULL_REQUEST" != 'false' ]]; then
  exit 0
fi

if [[ "$TRAVIS_BRANCH" = 'master' ]]; then
  echo "Deploying branch $TRAVIS_BRANCH..."
  mvn -V -B -s travis/settings.xml clean deploy -DskipTests
  exit 0
fi

if [[ "$TRAVIS_BRANCH" =~ ^[0-9]+(\.[0-9]+)*(\-[0-9]+)?$ ]]; then
  echo "Deploying branch $TRAVIS_BRANCH..."
  openssl aes-256-cbc -K $encrypted_e953c0e21635_key -iv $encrypted_e953c0e21635_iv -in travis/codesigning.asc.enc -out travis/codesigning.asc -d
  gpg --fast-import travis/codesigning.asc
  mvn -V -B -s travis/settings.xml clean deploy -P sign -DskipTests
  exit 0
fi

echo "Branch $TRAVIS_BRANCH not eligible for deployment."
