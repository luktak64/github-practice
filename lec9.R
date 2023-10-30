library(dplyr)
library(stringr)

census_df <- read.csv("est16us.csv")
food_cost_df <- read.csv("Food_Costs.csv")

#Data cleaning

#Goal - get rid of double Texas
#Remove all NA values which is logically the same as Keep al rows that don't have NA values
food_cost_df <- filter(food_cost_df, !is.na(Cumulative.Cost))

state_name <- str_trim(str_extract(food_cost_df$State.Agency.or.Indian.Tribal.Organization, "[^,]*$"))


state_name[str_length(state_name) == 2] <- state.name[match(state_name[str_length(state_name) == 2], state.abb)]


food_cost_df$state_name <- state_name

fd_grp <- group_by(food_cost_df, state_name)
food_clean_df <- summarize(fd_grp, yr_cost = sum(Cumulative.Cost))

combo_df <- merge(x=census_df, y = food_cost_df, 
                  by.x = "Name", by.y = "state_name",
                  all.x = TRUE)

sorted_df <- arrange(combo_df, -Poverty.Percent..All.Ages)
print(sorted_df$Name)
