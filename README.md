# TM-Cleaner
This repository contains the software to run the translation memory (TM) cleaning service developed during the CEF Data MarketPlace project](https://www.datamarketplace.eu). A service based on this tool is offered by the TAUS Data MarketPlace platform.

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

The Docker image of the code is available [here](https://drive.google.com/file/d/1PCv0kLT5K0adANgAZUqQeQpbHaKlxgu_/view?usp=sharing) (around 860 MB)

Once the Docker image has been downloaded, it has to be added to your docker environment
```bash
$ docker load < image.cleaning_service.tar.gz
```

To start the service, run the following command:
```bash
$ docker run --rm -it --net=host cleaning_service
```

Them wait until the process prints the message
```bash
web service ready at port 8081
```
this means it is ready to accept requests.

Requests can be issued at the following URLs:
* http://localhost:8081/cleaning_service.php
* http://${PUBLIC-IP}:8081/cleaning_service.php


### Example

The request
```bash
curl -X POST -F langpair=en-it -F power=0 -F verbosity=0 -F tu='Wash briefly with tap water.	Lavare rapidamente con acqua corrente.' http://localhost:8081/cleaning_service
```
produces the response:
```bash
{"status": 0,
 "info": "1\tWash briefly with tap water.\tLavare rapidamente con acqua corrente."}
```


## API specifications

The web service is exposed as a REST API, where REST is to be interpreted in the weak meaning (the web service here described does not use WSDL/SOAP but is defined directly over the HTTP protocol).

Two endpoints are exposed, one at the level of a TU and one at the level of a file containing TUs.

### /cleaning_service (endpoint at TU level)

HTTP Method: POST

Parameters:
* tu (string, mandatory): tab-separated source sentence and target sentence;
* langpair (string, mandatory): dash-separated source and target languages encoded with a two-char ISO 639-1 code (e.g. "en-it");
* power (integer, optional): it regulates the strenght of the cleaning process, with an integer in the set {0,1,2}, meaning respectively {low,average,high} strenght; provided values changes the BiCleaner threshold (respectively {0,0.4,0.7}); default value is 0;
* verbosity (integer, optional): value 0 means that only acceptance scores are provided (0 means reject, 1 means accept); value 1 means that also the TU are included in the respose; default value is 0;
* email (string, optional): an email address to which the results are to be sent;

Response:

The service sends a reply in JSON format to either acknowledge the success or to report an error. It include the attributes "status" and "info".

Success: the attribute "status" is 0 and the attribute "info" contains the acceptance score (0 means reject, 1 means accept). If verbosity is 1, then the input TU is also included.

Failure: the attribute "status" is 1 and the attribute "info" contains the error description.


### /document_cleaning_service (endpoint at file of TUs level)

HTTP Method: POST

Parameters are the same of the endpoint /cleaning_service but instead of "tu" the mandatory parameter is "userfile", a file containing TUs (one for line).

Response is the same of the endpoint /cleaning_service but the "info" attribute included multiple acceptance scores (one for each TU in the userfile).


## Web GUI (Graphical User Interface)

To test the tool, a web graphical interface is made available in the Docker. It consists of a simple web page, where a file containing one or more TUs can be uploaded and additional parameters can be set: the TUs in the uploaded file (one for line) are then processed by the tool returning the list of the decisions (0: dirty, 1: clean). The GUI allows the user to provide an email address to which the output of the tool is sent. 

## Credits

FBK developed the Cleaning Service (the web service, interface with BiCleaner and web GUI)


## Contacts

Please email cattoni AT fbk DOT eu




