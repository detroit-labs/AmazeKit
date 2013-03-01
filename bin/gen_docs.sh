#!/bin/sh

appledoc -o docs/ \
         -h \
	 --no-create-docset \
	 --project-name AmazeKit \
	 --project-company Detroit\ Labs \
	 --no-repeat-first-par \
	 AmazeKit/AmazeKit/
