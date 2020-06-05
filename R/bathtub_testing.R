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


#evap in AF and storage_initial in AF 

#lowest level should be 40,000 AF


outflow = function(input_df, storage_initial = 70555, k = 0.01, evap = 22.66, outflow_only = TRUE)
  
{
  
  bathtub_df <- data.frame(date = input_df$date,
                           year = input_df$year,
                           month = input_df$month, 
                           day = input_df$day,
                           flow_in = input_df$flow,
                           flow_out = k*storage_initial,
                           storage_new = storage_initial,
                           capacity = 129700,
                           storage_final = NA,
                           flow_out_final = NA) 
  
  # could take out the for loop and turn this into ode
  
  # if storage > capacity, add difference to flow out
  
  for (i in 2: nrow(bathtub_df)) {
    
    bathtub_df$storage_new[i] = bathtub_df$storage_new[i-1] - evap + bathtub_df$flow_in[i-1] - bathtub_df$flow_out[i-1]
    bathtub_df$flow_out[i] = bathtub_df$storage_new[i]*k
    
  }
  
  for(i in 2:nrow(bathtub_df)){
    if(bathtub_df$storage_new[i] > bathtub_df$capacity[i]){
      bathtub_df$storage_final[i] = bathtub_df$capacity[i]
      bathtub_df$flow_out_final[i] = bathtub_df$flow_in[i]
    }
    else{
      bathtub_df$storage_final[i] = bathtub_df$storage_new[i]
      bathtub_df$flow_out_final[i] = bathtub_df$flow_out[i]
    }
    
  }
  
  no_NA <- bathtub_df %>% 
    drop_na()
  
  mean_outflow <- mean(no_NA$flow_out_final)
  
  
  if(outflow_only){
    return(mean_outflow)
  }
  else{
    return(bathtub_df)
  }
  
  
}






