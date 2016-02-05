encoding-check/encoding-finder.perl

Suggest file encoding for middle european natural languages
===
This script determines the encoding system used in a file.


Requirements
---
Linux, FreeBSD, Solaris or Mac OS.
You will need to run the script in a Terminal.


Installation
---
If you want to install the all package copy the content of the repository on a local folder or execute a git clone request.
If you don't need the test environment only copy the file encoding-finder.perl on a local folder.


Usage
---
```sh
perl encoding-finder.perl <your_text_file.txt
```


Encoding sets
---
It works solely on the encodings:

* iso-latin-1 (ISO 8859-1)
* iso-latin-9 (ISO 8859-15) 
* utf-16-le   (ucs2-le)
* utf-16-be   (ucs2-be)
* utf-8

Do not use it for other encodings or it may not work correctly.
    

Character sets
---
It only WORKS on CHARACTER-SETS FOR THE following languages:

* italian
* german
* french
* english
* spanish

It may not work correctly with other natural languages


NOTES:
---
    We do not attempt to distinguish between utf-16 and ucs-2 because the differences are not manifested in the
    char-sets of the five languages listed above.
    Only the first 2 chars of a utf16 document are used to determine the character encoding (BOM byte order mark).
    Hence do not send strings which have been taken from the middle of a utf-16 document. Always send either the entire file
    (or at least the beginning part of a file).
    For the five languages above, iso-latin-1 and iso-latin-9 can only be differentiated based on the presence
     or absence of the "euro" charachter in a document.
    Unless there is evidence otherwise, the encoding is assumed to be iso-latin-1.

    
    IF YOU USE THIS PROGRAM WITH FILES OF OTHERS CHARSETS / LANGUAGES:
    - Almost every extended charset of ASCII will be interpreted as ISO-Latin-1.
    - Every Iso 8859- between 2 and 14 will be recognized as either iso-8859-1 or iso-8859-15
    - utf16 will only be recognized if the begin of the file is not damaged,
      in this case the language does not play a role.
    - utf8 will also be recognized in documents written in  most european and asian languages.
