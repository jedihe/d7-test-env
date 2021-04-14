#!/bin/bash

DRUPAL_BRANCH=7.x
[ ! -d web ] &&
  git clone --depth 1 --branch $DRUPAL_BRANCH https://git.drupalcode.org/project/drupal.git web &&
  cd web &&
  git apply <(curl -SsL https://www.drupal.org/files/issues/2021-04-14/2390749-drupal-run-tests-single-method-21.patch) &&
  cd ..

lando start

lando drush si --db-url="mysql://drupal7:drupal7@database/drupal7" --account-pass=admin -y

echo "Running RdfCrudTestCase test with run-tests.sh..."
echo "================================================"
lando drush en -y simpletest
lando run-tests --verbose --php /usr/local/bin/php --url "http://localhost" --class "RdfCrudTestCase"

[[ -n $1 ]] &&
  lando drush dl $1 -y
