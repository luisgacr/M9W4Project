---
title       : M9W4Project 
subtitle    : Colombian Peso exchange rate (vs US Dollar)
author      : Luis Caro
job         : Director Finac
framework   : io2012        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : []            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
github      : 
  user      : luisgacr
  repo      : M9W4Project
knit        : slidify::knit2slides
---

## Purpose

The purpose of the website is:
  
  - Display the Colombian Peso (COP) exchange rate (vs USD) in table
- Plot the exchange rates vs the dates
- Plot the daily rate differences. This can be done in two ways:
  -- Display the differences of the absolute rates
-- Display the differences of the logarithms of the rates.

The user can select:
  - The range in dates of the rates that will be displayed
- The type of rate difference that will be displayed (absolute rate or rate logarithm)


---
## Instructions
  
  There are two date fields:
  - The initial plot date (date of the first rate and difference)
-- The minimum date allowed for this field is 1991-11-28, and the maximun value is 2017-03-28
- The final plot data (date of last rate and difference)
-- The minimum date allowed for this field is 1991-12-01, and the maximun value is 2017-03-28

There is a selector where the user can select the type of difference to display:
  - Absolute
- Logarithm


---
## Instructions (continued)
  
  In the bottom of the side bar, there is a button <Create plots>. The user must press this button to display the plots in the folowing cases:
  - When the website is initiated
- Every time any date is changed

The differences chart is updated automatically when the user selects a new type of difference.

The plots were built using "plotly"; therefore all the provided by this type of plot is avialable to the user


---
## Data
  
  The rates are stored in a mongoDB database, hosted in mlab.com. Everytime the website is initiated, the rates are downloaded. 




