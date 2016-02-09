## Final Helper function

## Prep data and draft function.

require(dplyr)
require(RCurl)
require(reshape2)
require(RColorBrewer)
require(scales)
require(ggplot2)

totalCostTable <- function(liveBirths=790000, xPreterm=0.0048, vPreterm=0.0123,
                           mPreterm=0.0546, start=1, end=10, cost='total', indirect=TRUE) {
  
  xP <- liveBirths*xPreterm
  vP <- liveBirths*vPreterm
  mP <- liveBirths*mPreterm
  
  for(i in seq_along(data$premie_cat)) {
    
    if (data$premie_cat[i]==28) {
      data$tot_cost[i] = data$cost[i]*xP
    } else if (data$premie_cat[i]==32) {
      data$tot_cost[i] = data$cost[i]*vP
    } else if (data$premie_cat[i]==36) {
      data$tot_cost[i] = data$cost[i]*mP
    }
    
  }
  
  if (cost == "total") {
    df <- data %>%
      filter(year_x >= start & year_x <= end) %>%
      group_by(cost_cat) %>%
      mutate(total_cost = sum(tot_cost)) %>%
      select(cost_cat, total_cost) %>%
      distinct()
    
    df$total_cost <- prettyNum(df$total_cost, big.mark=",", preserve.width="none")
  } else {
    df <- data %>%
      filter(year_x >= start & year_x <= end) %>%
      group_by(cost_cat) %>%
      mutate(cost_per_case = sum(cost)) %>%
      select(cost_cat, cost_per_case) %>%
      distinct()
    
    df$cost_per_case <- prettyNum(df$cost_per_case, big.mark=",", preserve.width="none")
  }
  
  df
  
}

######## PLOT FUNCTION

plotMaker <- function(liveBirths=790000, xPreterm=0.0048, vPreterm=0.0123,
                      mPreterm=0.0546, start=1, end=10, cost='total', indirect=TRUE) {
  
  xP <- liveBirths*xPreterm
  vP <- liveBirths*vPreterm
  mP <- liveBirths*mPreterm
  
  for(i in seq_along(data$premie_cat)) {
    
    if (data$premie_cat[i]==28) {
      data$tot_cost[i] = data$cost[i]*xP/1000000 #divide by a million to reduce scale for plotting
    } else if (data$premie_cat[i]==32) {
      data$tot_cost[i] = data$cost[i]*vP/1000000
    } else if (data$premie_cat[i]==36) {
      data$tot_cost[i] = data$cost[i]*mP/1000000
    }
  }
  #indirect selector
    if (indirect == FALSE) {
    data <- filter(data, !grepl('indirect_cost', cost_cat))
  }
  
  #year selector and total cost mutator
  df <- data %>%
    filter(year_x >= start & year_x <= end) %>%
    group_by(premie_cat, cost_cat) %>%
    mutate(each_cost = sum(cost)) %>%
    mutate(total = sum(tot_cost)) %>%
    select(premie_cat, cost_cat, each_cost, total) %>%
    distinct()
  
  #convert premie_cat to character for plot
  df$premie_cat <- as.character(df$premie_cat)
  
  #create color scheme for stack plot.
  colors <- brewer.pal(11, "Spectral")
  myCols <- pal(11)
  names(myCols) <- levels(df$cost_cat)
  colScale <- scale_fill_manual(name='Resource Use', values=myCols)
  
  #plotting by cost or tot
  
  if (cost == 'total') {
    g <- ggplot(df, aes(x=premie_cat, y=total, fill=cost_cat)) +
      geom_bar(position='stack', stat='identity') +
      colScale + 
      scale_y_continuous(name='Total Cost (Million GBP)', labels = comma) +
      xlab('Max Gestational Weeks')
  } else if (cost == 'costPerCase') {
    g <- ggplot(df, aes(x=premie_cat, y=each_cost, fill=cost_cat)) +
      geom_bar(position='stack', stat='identity') +
      colScale + 
      scale_y_continuous(name='Cost per Newborn (GBP)', labels = comma) +
      xlab('Max Gestational Weeks') 
  }
  g
  
}
