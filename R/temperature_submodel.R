# Temperature Model

# https://ascelibrary.org/doi/10.1061/%28ASCE%290733-9372%282005%29131%3A1%28139%29
#The majority of streams showed an increase in water temperature of about 0.6–0.8°C for every 1°C increase in air temperature




# temp_a = air temp
# temp_w = water temp
# c = temperature coefficient = 0.7 or could do sensitivity testing on that as well

# are we interested in the daily change in temp or just the daily temp ignoring previous day?



water_temp = function(temp_a, temp_w, time, discharge){
  
  # the more discharge, the smaller c should be, but have some floor so it doesn't go all the way to zero
  
  c = discharge*#something to make c smaller as discharge gets bigger
  
  if(temp_a > temp_w)
    return(temp_a*c*temp_w)
  
  if(temp_w > temp_a)
    return(temp_w)
  
}



#can we build water volume into c? Maybe c changes with volume, smaller c means faster/more change in temp, larger c means less temp change 

