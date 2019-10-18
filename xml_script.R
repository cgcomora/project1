#read in the xml file
library(dplyr)
library(xml2)
library(XML)
library(plyr)
library(DT)
library(ggplot2)


xmlfile <- xmlParse("census.xml")

#determine class of file
class(xmlfile) #"XMLInternalDocument" "XMLAbstractDocument"

xmltop = xmlRoot(xmlfile) #gives contents of root
class(xmltop)
xmlName(xmltop) #gives name of node, response
xmlSize(xmltop) #how many children in node,1
xmlName(xmltop[[1]]) #name of root's children, "row"

#look at first child entry
xmltop[[1]]

#since there is only 1 child entry, the second is null
xmltop[[2]] #NULL
xmltop[[2]]

#how many nodes are in the child
xmlSize(xmltop[[1]]) #430 nodes in child
xmlSApply(xmltop[[1]],xmlName) #names of each
xmlSApply(xmltop[[1]],xmlAttrs)
xmlSApply(xmltop[[1]],xmlSize)
xmltop[1:22]

#I can get to a list of lists
View(xmlToList(xmltop[[1]]))

#unlist the lists to a vector
xml_list <- xmlToList(xmltop[[1]])
xml_unlist <- unlist(xml_list)

#coerce xml list to dataframe
xml_df <- (ldply(xml_list,data.frame))
xml_df_nodup <- xml_df[!duplicated(xml_df$unique_id),]
View(xml_df_nodup)

#coerce to a table
my_table <- datatable(xml_df_nodup)
my_table

xml_df_nodup$population_white <- as.numeric(xml_df_nodup$population_white)
xml_df_nodup$population_black <- as.numeric(xml_df_nodup$population_black)
xml_df_nodup$median_household_income <- as.numeric(xml_df_nodup$median_household_income)
xml_df_nodup$masters_degree_male <- as.numeric(xml_df_nodup$masters_degree_male)
g <- ggplot(data = xml_df_nodup, aes(x = xml_df_nodup$median_household_income,y = xml_df_nodup$masters_degree_male))
g + geom_point() + geom_smooth(method = lm) +facet_wrap(~xml_df_nodup$block_group)
