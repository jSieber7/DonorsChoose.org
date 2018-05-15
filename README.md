# DonorsChoose.org

This project seeks to analyzing DonorsChoose.org in order to generate business insights that will drive more dollars into the hands of teachers across America. The tool of choice is R. All data taken from https://www.kaggle.com/donorschoose/io.

The code that will be used in the final kernel is inside the 'Telling a Story' IPYNB file, other files serve as exploration and modeling at the moment.


## Current Approach:

The greatest chance in building a good recommendation system as of now seems to be generating a discriptive set of features about a project, and recommending other projects to users based on a distance measure (cosign, Jaccard, ect.)  between projects. Also, grouping similar users based on a discriptive set of features (PCA or SVD may be required) with a distance masure may be useful aswell.  Creating decent clusters out of this data seems doubtful, but will make an attempt. My current activity is using topic modeling to add a new discriptive feature for each project.



