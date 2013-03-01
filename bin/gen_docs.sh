#!/bin/sh

appledoc -o docs/ \
         -h \
	 --create-docset \
	 --no-install-docset \
	 --project-name AmazeKit \
	 --project-company Detroit\ Labs \
	 --project-version $(cat VERSION) \
	 --company-id com.detroitlabs \
	 --no-repeat-first-par \
	 AmazeKit/AmazeKit/

appledoc -o docs/ \
         -h \
	 --no-create-docset \
	 --create-html \
	 --project-name AmazeKit \
	 --project-company Detroit\ Labs \
	 --project-version $(cat VERSION) \
	 --company-id com.detroitlabs \
	 --no-repeat-first-par \
	 AmazeKit/AmazeKit/
