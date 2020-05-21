# Melt submodel

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

melt = function(mf, temp) # think we will need to add a time/day component?
  {
  if(temp < 0)
    return(melt = 0)
  
  if(temp > 0)
    return(melt = mf*temp)
}


