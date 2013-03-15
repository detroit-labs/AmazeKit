#!/bin/sh

appledoc -o docs/ \
	 -d \
	 --clean-output \
	 --project-name AmazeKit \
	 --project-company Detroit\ Labs \
	 --project-version $(cat VERSION) \
	 --company-id com.detroitlabs \
	 --no-repeat-first-par \
	 --docset-feed-url http://amazekit.com/downloads/%DOCSETATOMFILENAME \
	 --docset-package-url http://amazekit.com/downloads/%DOCSETPACKAGEFILENAME \
	 --publish-docset \
	 AmazeKit/AmazeKit/

appledoc -o docs/ \
         -h \
	 --no-create-docset \
	 --create-html \
	 --no-keep-undocumented-objects \
	 --no-keep-undocumented-members \
	 --no-search-undocumented-doc \
	 --project-name AmazeKit \
	 --project-company Detroit\ Labs \
	 --project-version $(cat VERSION) \
	 --company-id com.detroitlabs \
	 --no-repeat-first-par \
	 AmazeKit/AmazeKit/
