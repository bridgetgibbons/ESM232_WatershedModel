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
# daily average evaporation = 0.1 in: in AF = 0.00833333 ft x 2720 acres = 22.66 AF


# we are probably going to need a starting storage value - could be a random choice that is adjustable in the model
# start with 100,000 af?

#evap in AF and storage_initial in AF 


outflow = function(input_df, storage_initial = 70555, k = 0.001, evap = 22.66)
  
{
  
  bathtub_df <- data.frame(date = input_df$date,
                           year = input_df$year,
                           month = input_df$month, 
                           day = input_df$day,
                           flow_in = input_df$flow,
                           flow_out = k*storage_initial,
                           storage_new = storage_initial) 
  

 
  for (i in 2: nrow(bathtub_df)) {
    
    bathtub_df$storage_new[i] = bathtub_df$storage_new[i-1] - evap + input_df$flow_in[i-1] - bathtub_df$flow_out[i-1]
    bathtub_df$flow_out[i] = bathtub_df$storage_new[i]*k
    
  }
  
  return(bathtub_df)
  
}

#look at Naomi reservoir example 
#we need a term for evap losses
#look at R reservoir package 


# rethinking this and wondering if we should have a constant k value not dependent on storage and then run sensitivity on that for #simplicity


# make sure if storage < 0, evap and drainage are 0

# wrapper function that updates storage and melt each day

# make sure all units match up in whatever unit we choose

# evap = surface area of reservoir * evap rate

# need to have some initial storage to start from

# storage_new = storage + flow - evap - k*storage #not sure if this will work but that notation should pull from the previous row value

# right now we are assuming reservoir has infinite capacity - if storage > storage capacity, add difference into discharge 


# not sure how to set this one up, needs to be something about the sum of previous day melt minus the discharge rate or something?? 



