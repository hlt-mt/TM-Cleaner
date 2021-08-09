# TM-Cleaner
This repository contains the software to run the translation memory (TM) cleaning service developed within the [CEF Data MarketPlace project](https://www.datamarketplace.eu). A service based on this tool is offered by the TAUS Data MarketPlace platform.

The goal of the tool is to remove wrong or dirty translation units (TUs) from the TMs uploaded to the Marketplace. This is obtained by running a software able to extract features from the source and target language sides of a TU and to take a decision about the overall quality of the TU.

The identification of “bad” TUs is a multifaceted problem. First, it deals with the recognition of a variety of errors. These include:

• Surface errors, such as opening/closing tags inconsistencies and empty or suspiciously long/short translations;

• Language inconsistencies, for instance due to the inversion between the source and target languages;

• Translation fluency issues, such as typos and grammatical errors (e.g. morpho-syntactic disagreements, wrong word ordering);

• Translation adequacy issues, such a sthe presence of untranslated terms, wrong lexical choices or more complex phenomena (e.g. negation and quantification errors) for which a syntactically correct target can be a semantically poor translation of the source segment.



## The tool
The tool is based on the sentence embeddings provided by the [LASER suite](https://github.com/facebookresearch/LASER). Given a TU, the sentence embeddings are extracted for both the source and target sentences, each with respect to their own language. Then the cosyne similarity between the source embeddings and the target embeddings is computed: if it overcomes a threshold then the TU is labeled as clean, otherwise as dirty.

It is worth noticing here that LASER is able to manage at least 93 language, giving the tool the ability to support multilinguality.

The tool is accessible by an API that allows a user to process one or multiple TUs at the time. More details about the API specifications are available below.


## Installation and Usage

The Docker image of the code is available [here](https://drive.google.com/file/d/1pNMN7EIaWLefwTljC6KbOlw_NlffH_sX/view?usp=sharing) (around 2 GB)

No specific hardware or software is required in addition to a working "docker" installation (only the optional "email" functionality requires an email sending service running on the host)

Once the Docker image has been downloaded, it has to be added to your docker environment
```bash
$ docker load < image.cleaning_service_y2.tar.gz
```

To start the service, run the following command:
```bash
$ docker run --rm -it --net=host cleaning_service_y2
```

Then wait until the process prints the message
```bash
web service ready at port 8081
```
this means it is ready to accept requests.

Requests can be issued at the following URLs:
* http://localhost:8081/cleaning_service
* http://${PUBLIC-IP}:8081/cleaning_service


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

Two endpoints are exposed, one at the level of TU and one at the level of file containing TUs.

### /cleaning_service (endpoint at TU level)

HTTP Method: POST

Parameters:
* tu (string, mandatory): tab-separated source sentence and target sentence;
* langpair (string, mandatory): dash-separated source and target languages encoded with a two-char ISO 639-1 code (e.g. "en-it");
* power (integer, optional): it regulates the strenght of the cleaning process, with an integer in the set {0,1,2}, meaning respectively {low,average,high} strenght; provided values changes the threshold for the cosyne similarity (respectively {0.7,0.8,0.9}); default value is 0.7;
* verbosity (integer, optional): one of 0 (default) or 1; value 0 means that only decision scores are provided (0: dirty, 1: clean); value 1 means that also the TU are included in the response;
* email (string, optional): an email address to which the results are to be sent;

Response:

The service sends a reply in JSON format to either acknowledge the success or to report an error. It includes the attributes "status" and "info".

Success: the attribute "status" is 0 and the attribute "info" contains the decision score (0: dirty, 1: clean). If verbosity is 1, then the input TU is also included.

Failure: the attribute "status" is 1 and the attribute "info" contains the error description.


### /document_cleaning_service (endpoint at file of TUs level)

HTTP Method: POST

Parameters are the same of the endpoint /cleaning_service but instead of "tu" the mandatory parameter is "userfile", a file containing TUs (one for line).

Response is the same of the endpoint /cleaning_service but the "info" attribute included multiple acceptance scores (one for each TU in the userfile).


## Web GUI (Graphical User Interface)

To test the tool, a web graphical interface is made available in the Docker. It consists of a simple web page, where a file containing one or more TUs can be uploaded and additional parameters can be set: the TUs in the uploaded file (one for line) are then processed by the tool returning the list of the decisions (0: dirty, 1: clean). The GUI allows the user to provide an email address to which the output of the tool is sent. 

## Credits

FBK developed the Cleaning Service (the web service and web GUI)


## Contacts

Please email cattoni AT fbk DOT eu




