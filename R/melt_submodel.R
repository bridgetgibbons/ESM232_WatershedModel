# Melt submodel

# https://directives.sc.egov.usda.gov/OpenNonWebContent.aspx?content=17753.wba
# see page 11 - same method as described below

# http://snobear.colorado.edu/Markw//IntroHydro/09/snow/snow_hydro_modeling.htm
# M = Mf (Ta - To)
# M = snowmelt (mm/day)
# Mf = degree day factor (mm/degreeC/day)
# Ta = air temp (degrees C); daily mean, daytime mean, maximum daily Ta; user must decide
# To = threshold or base temperature (degreesC) above which snow melt occurs, usually 0 degreesC - make this constant at 0 degrees so it doesn't affect the equation
# range is usually 1 mm/degreeC/day < Mf < 7 mm/degreeC/day
# The degree-day factor is the heart of the approach.
# The degree-day factor must be calibrated for each basin and may change with elevation on the same time step and over time at the same point within a basin.


# headwaters area = 72.5 miles^2 , 46400 acres
# approx SWE feeding bathtub = headwaters_area*SWE

#SWE in inches at start of day 

#Drainage of 72.5 square miles

#mf ft/C/day
# 1 - 7: 1 mm = 0.00328084 ft, 4mm = 0.0131234 ft, 7mm = 0.0229659 ft




melt = function(mf = 0.0131234, SWE, input_year, flow_only = TRUE) # think we will need to add a time/day component and SWE but im not sure where/how?
  
  {
  
  swe_df <- SWE %>% 
    filter(year == input_year) 
  
  output_df <- data.frame(date = swe_df$Date,
                          year = swe_df$year,
                          month = swe_df$month, 
                          day = swe_df$day,
                          temp = swe_df$temp,
                          melt_factor = NA,
                          tot_SWE = NA,
                          flow = NA)
  
  for (i in 1: nrow(swe_df)) { 
    output_df$melt_factor[i] = ifelse(swe_df$temp[i] < 0, 0, mf*swe_df$temp[i])
    output_df$tot_SWE[i] = 464000*(swe_df$swe_ft[i])# get total water equivalent for the headwaters area in acrefeet
    output_df$flow[i] = output_df$melt_factor[i]*output_df$tot_SWE[i] }
  
  
  for(i in 2:nrow(swe_df)){
    if(output_df$tot_SWE[i] >= output_df$tot_SWE[i-1]){
      output_df$flow[i] = 0
    }
    else{
    output_df$melt_factor[i] = ifelse(swe_df$temp[i] < 0, 0, mf*swe_df$temp[i])
    output_df$tot_SWE[i] = 464000*(swe_df$swe_ft[i])# get total water equivalent for the headwaters area in acrefeet
    output_df$flow[i] = output_df$melt_factor[i]*output_df$tot_SWE[i-1]  
    }
  }
  
  mean_flow = mean(output_df$flow)
  
  if(flow_only){
    return(mean_flow)
  }
  else{
    return(output_df)
  }
  
  
}


