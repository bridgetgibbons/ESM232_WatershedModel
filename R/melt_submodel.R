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


# we could also run sensitivity analysis on this mf term, could be interesting to see how much the whole deal changes based on that


# headwaters area = 72.5 miles^2 , 46400 acres
# approx SWE feeding bathtub = headwaters_area*SWE

#SWE in inches at start of day 

#Drainage of 72.5 square miles

melt = function(mf, temp, SWE) # think we will need to add a time/day component and SWE but im not sure where/how?
  {
  if(temp <= 0)
    return(melt_factor = 0)
  
  if(temp > 0)
    return(melt_factor = mf*temp)
  
  if(SWE = 0)
    return(NA)
  
  tot_SWE = 464000*(SWE/12) # get total water equivalent for the headwaters area in acrefeet
  
  
  flow = melt_factor*tot_SWE
  
  return(flow)
  
}

#error checking, if no SWE or not enough, error 

# i think this function needs either a for loop or to use mapply - if the input is daily temperature and SWE data, would we get a value of flow per day? I'm thinking we may want it to run line by line down a data frame, and then it can calculate the daily flow rate, which I think is what we want to feed into the bathtub


