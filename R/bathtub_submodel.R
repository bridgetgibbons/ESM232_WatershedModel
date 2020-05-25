# Bathtub model


# flow = flow rate in (returned from melt model)
# capacity = capacity of the reservoir (129,700 af) 
# storage = current volume of water in reservoir (previous day storage + melt - discharge - evap)
# k = drainage rate (cfs?)
# evap = average daily evaporation (constant at 0.1 in/day)
# discharge = k*86400 (daily discharge = discharge rate * seconds in a day)  ?????


# reservoir that is going to be our 'bathtub' is Vallecito Reservoir
# capacity = 129,700 af
# The surface area of the reservoir at maximum capacity is 2,720 acres.
# https://wrcc.dri.edu/Climate/comp_table_show.php?stype=pan_evap_avg
# average annual evaporation = 37.67 in
# daily average evaporation = 0.1 in


# we are probably going to need a starting storage value - could be a random choice that is adjustable in the model
# start with 100,000 af?


outflow = function(flow, storage, k)
{
  
  # rethinking this and wondering if we should have a constant k value not dependent on storage and then run sensitivity on that for #simplicity
  # 
  # if(storage < 0.3*capacity)
  #   return(k = 0.1) 
  # 
  # if(0.3*capacity < storage < 0.6*capacity)
  #   return(k = 0.2)
  # 
  # if(storage > 0.6*capacity)
  #   return(k = 0.3)
  # 
  
  
  
  storage = storage[.I-1] + flow - evap - k*storage #not sure if this will work but that notation should pull from the previous row value
  
  discharge = k
  
  
  
  
  # not sure how to set this one up, needs to be something about the sum of previous day melt minus the discharge rate or something?? 
}

#look at Naomi reservoir example 
#we need a term for evap losses
#look at R reservoir package 





