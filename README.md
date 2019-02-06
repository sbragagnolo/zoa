# Install 
State of the art managing tool 
 $ mkdir $HOME/bin/zoa
 $ cd $HOME/bin/zoa
 $  wget -O- get.pharo.org/70+vm | bash 
   
 $ ./pharo-ui Pharo.image eval "Metacello new
     baseline: 'Zoa';
     repository: 'github://sbragagnolo/zoa/src';
     load."


# Alias 

echo "alias zoa=\"$HOME/bin/zoa/pharo $HOME/bin/zoa/Pharo.image clap zoa\"" >> .bashrc #.zshrc 


# Use
zoa --help 
 bibtex      Gets the bibtex of a given doi 
    brief       Sets a brief on an article 
    browse      (Web)Browses the PDF of all the matching articles. if it is
    cite        Sets a cite on an article 
    fetch       Fetch an article  (Only works with ACM, IEEE, ArxIv and ResearchGate articles) 
    getpdf      Downloads the PDF of all the matching articles. if it is
    list        List available entries
    read        Open the PDF of all the matching articles. if it is
    tag         Adds or remove a tag from a document 
    submit      it executes git add .; git commit -m ":neesage" ; git pull; push. Super naive " 



## zoa fetch --help
Fetch an article  (Only works with ACM, IEEE, ArxIv and ResearchGate articles) 

Usage: fetch [--help] [--url] [--doi] [<value>]

Parameters:
    <value>     [{URL*} | {DOI*}

Options:
    --help      Prints this documentation
    --url       Fetches by Url
    --doi       Fetches by Doi


## zoa list --help
List available entries

Usage: list [--help] [--t] [--a] [--d] [--tag] [--ct] [--kw] [--b] [--fd=Value] [--ft=Value] [--fct=Value] [--fkw=Value] [--ftag=Value] [--fabs=Value] [--fbr=Value]

Named Parameters:
    --fd        Filters by Doi
    --ft        Filters by title
    --fct       Filters by Cite
    --fkw       Filters by Keywords
    --ftag      Filters by Tags
    --fabs      Filters by abstract
    --fbr       Filters by briefs

Options:
    --help      Prints this documentation
    --t         Shows title
    --a         Shows abstract
    --d         Shows Doi
    --tag       Shows tags
    --ct        Shows cite
    --kw        Shows keywords
    --b         Shows briefs

... etc. 











