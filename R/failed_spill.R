



outflow = function(input_df, storage_initial = 70555, k = 0.001, evap = 22.66, capacity = 129700)
  
{
  
  bathtub_df <- data.frame(date = input_df$date,
                           year = input_df$year,
                           month = input_df$month, 
                           day = input_df$day,
                           flow_in = input_df$flow,
                           flow_out = k*storage_initial,
                           storage_new = storage_initial,
                           spill = NA) 
  
  # could take out the for loop and turn this into ode
  
  # if storage > capacity, add difference to flow out
  
  for (i in 2: nrow(bathtub_df)) {
    
    
    
    bathtub_df$storage_new[i] = bathtub_df$storage_new[i-1] - evap + bathtub_df$flow_in[i-1] - bathtub_df$flow_out[i-1]
    bathtub_df$flow_out[i] = bathtub_df$storage_new[i]*k
    
    
    if(bathtub_df$storage_new[i] > capacity){
      bathtub_df$spill[i] = bathtub_df$storage_new[i] - capacity
    } else{bathtub_df$spill[i] = 0}
  }
  
  
  for (i in 2: nrow(bathtub_df)) {
    
    bathtub_df$storage_new[i] = bathtub_df$storage_new[i-1] - evap + bathtub_df$flow_in[i-1] - bathtub_df$flow_out[i-1]
    bathtub_df$flow_out[i] = bathtub_df$storage_new[i-1]*k + bathtub_df$spill[i-1]
  }
  
  
  return(bathtub_df)
  
}
