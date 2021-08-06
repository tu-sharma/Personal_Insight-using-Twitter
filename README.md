# Personal Insight using Twitter DATA

![Banner](https://github.com/tusharma78/Personal_Insight-using-Twitter/blob/main/Image/Banner.png)

Personal Insight using Twitter Data is R and Python based Project to analyze data of Twitter using Twitter's Handle.

## [Rtweet](https://www.rdocumentation.org/packages/rtweet/versions/0.7.0)
[rtweet](https://cran.r-project.org/web/packages/rtweet/rtweet.pdf) is R client for accessing Twitter’s REST and stream APIs. It provides several features to access twitter data respect to their utilities. 

### Installation 
To get current version from CRAN:

```
## install rtweet from CRAN
install.packages("rtweet")

## load rtweet package
library(rtweet)
```
To get the current development version from Github:
```
## install remotes package if it's not already
if (!requireNamespace("remotes", quietly = TRUE)) {
  install.packages("remotes")
}

## install dev version of rtweet from github
remotes::install_github("ropensci/rtweet")

## load rtweet package
library(rtweet)
```
[For More](https://www.rdocumentation.org/packages/rtweet/versions/0.7.0)

## Personal Insight

Twitter Handle used as input to access twitter data using rtweet. User's Handle provide the all data of their twitter timeline of *3200* tweets. Rtweet feature help to handle and preprocess the data for our desired result. 

After getting the data, can be use for analytics like recent timeline as shown in screenshot :


![Timeline](https://github.com/tusharma78/Personal_Insight-using-Twitter/blob/main/Image/timelineshot.jpg)


Here are some screenshot of Desktop Application to generate report of Personal Insight as *Output.html*.
<p align="center">
  <img width="800" height="600" src="https://github.com/tusharma78/Personal_Insight-using-Twitter/blob/main/Image/DeskApp1.PNG">
</p>

![Pesonal Insight](https://github.com/tusharma78/Personal_Insight-using-Twitter/blob/main/Image/personalityshot.jpg)

#### Flow Chart
<p align="center">
  <img width="800" height="600" src="https://github.com/tusharma78/Personal_Insight-using-Twitter/blob/main/Image/Twitter_PI.png">
</p>

### Instructions 

To run the GUI

```
$ python3 Application.py
```
or

Generate *Report* using terminal

```
$ R -e "rmarkdown::render('new_r.Rmd',output_file='output.html')"
```
