#!/bin/bash

DRUPAL_BRANCH=7.x
[ ! -d web ] &&
  git clone --depth 1 --branch $DRUPAL_BRANCH https://git.drupalcode.org/project/drupal.git web &&
  cd web &&
  git apply <(curl -SsL https://git.drupalcode.org/project/drupal/-/commit/9f42db5c081f64ef22b845eb84892ba3d05856bb.diff) &&
  cd ..

lando start

lando drush si --db-url="mysql://drupal7:drupal7@database/drupal7" --account-pass=admin -y

echo "Running RdfCrudTestCase test with run-tests.sh..."
echo "================================================"
lando drush en -y simpletest
lando run-tests --verbose --php /usr/local/bin/php --url "http://localhost" --class "RdfCrudTestCase"

[[ -n $1 ]] &&
  lando drush dl $1 -y
