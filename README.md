# TM-Cleaner
This repository contains the software to run the translation memory (TM) cleaning service developed during the CEF Data MarketPlace project.

The goal of the tool is to remove wrong or dirty translation units (TU) from the TMs uploaded to the Marketplace. This is obtained by running a software able to extract features from the source and target-language sides of a TU and to take a decision about the overall quality of the TU.

The identification of “bad” TUs is a multifaceted problem. First, it deals with the recognition of a variety of errors. These include:

• Surface errors, such as opening/closing tags inconsistencies and empty or suspiciously long/short translations;

• Language inconsistencies, for instance due to the inversion between the source and target languages;

• Translation fluency issues, such as typos and grammatical errors (e.g. morpho-syntactic disagreements, wrong word ordering);

• Translation adequacy issues, such a sthe presence of untranslated terms, wrong lexical choices or more complex phenomena (e.g. negation and quantification errors) for which a syntactically correct target can be a semantically poor translation of the source segment.



## The tool
The tool includes the [BiCleaner](https://github.com/bitextor/bicleaner) software. BiCleaner applies a two step process for deciding if a TU is correct or wrong. Initialy, it use a set of hard-coded rules such as languages verification, encoding errors, very different lengths in parallel sentences, etc. If a TU passes these rules, lexical and shallow features are extracted from the source and target sentences and then a classifier assignes a score from 0 (dirty) to 1 (clean). A cutting-threshold on the classifier score is used to take the final decision.

BiCleaner gives the possibility to use several classification algorithms such as svm, nn, adaboost, random forest, extremelly randomized tree, etc. The classifier should be trained and models are avialable covering 30 languages (3 Spanish-*, 1 German-Italian, 26 English-*).

The tool is accessible by an API that allows a user to process one or multiple TUs at the time. More details about the API specifications are available below.


## Installation and Usage

The Docker image of the code is available here  (around 3GB) 


Once the Docker image has been downloaded, it has to be added to your docker environment
```bash
$ docker load < image.cleaning_service.tar.gz
```

To start the service, run the following command:
```bash
$ docker run --rm -it --publish 8080:8080 cleaning_service
```

The process prints different information, when it prints the message
```bash
web service ready at port 8080
```
this means it is ready to accept requests.

Requests can be issued at the following URLs:
* http://localhost:8080/cleaning_service.php
* http://${PUBLIC-IP}:8080/cleaning_service.php


### Example

TBD


## API specifications

[The API specs of the Cleaning Service are available here](https:)

## Web GUI (Graphical User Interface)

To test the tool, a web graphical interface is made available in the Docker. It consists of a simple web page, where one or more TUs can be inserted and they are processed by the tool returning the list of the decisions (0: dirty, 1: clean). The GUI allows the user to provide an email address to which the output of the tool is sent. 

## Credits

FBK developed the Cleaning Service:
* FBK for the web service, interface with BiCleaner, web GUI and integration;


## Contacts

Please email cattoni AT fbk DOT eu




