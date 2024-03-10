#!/bin/sh

mvn install:install-file -Dfile=C:/Users/selva/Documents/code/sync-bb-sp2-to-gh-spd/all-be-lib/bt-common-util-be-0.0.1-SNAPSHOT.jar \
    -DgroupId=com.beamteq.common -DartifactId=common-util-be -Dversion=2.0.0-SNAPSHOT -Dpackaging=jar
mvn install:install-file -Dfile=C:/Users/selva/Documents/code/sync-bb-sp2-to-gh-spd/all-be-lib/bt-common-service-be-0.0.1-SNAPSHOT.jar \
    -DgroupId=com.beamteq.common -DartifactId=common-service-be -Dversion=2.0.0-SNAPSHOT -Dpackaging=jar
mvn install:install-file -Dfile=C:/Users/selva/Documents/code/sync-bb-sp2-to-gh-spd/all-be-lib/cms-be-0.0.1-SNAPSHOT.jar \
    -DgroupId=com.beamteq.cms -DartifactId=cms-be -Dversion=2.0.0-SNAPSHOT -Dpackaging=jar
mvn install:install-file -Dfile=C:/Users/selva/Documents/code/sync-bb-sp2-to-gh-spd/all-be-lib/ecommerce-be-0.0.1-SNAPSHOT.jar \
    -DgroupId=com.beamteq.ecom -DartifactId=ecom-be -Dversion=2.0.0-SNAPSHOT -Dpackaging=jar
mvn install:install-file -Dfile=C:/Users/selva/Documents/code/sync-bb-sp2-to-gh-spd/all-be-lib/matrimony-be-0.0.1-SNAPSHOT.jar \
    -DgroupId=com.beamteq.matrim -DartifactId=matrimony-be -Dversion=2.0.0-SNAPSHOT -Dpackaging=jar
mvn install:install-file -Dfile=C:/Users/selva/Documents/code/sync-bb-sp2-to-gh-spd/all-be-lib/survey-0.0.1-SNAPSHOT.jar \
    -DgroupId=com.beamteq.survey -DartifactId=survey-be -Dversion=2.0.0-SNAPSHOT -Dpackaging=jar
