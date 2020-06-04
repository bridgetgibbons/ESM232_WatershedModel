# Temperature Model

# https://ascelibrary.org/doi/10.1061/%28ASCE%290733-9372%282005%29131%3A1%28139%29
#The majority of streams showed an increase in water temperature of about 0.6–0.8°C for every 1°C increase in air temperature




# temp_a = air temp
# temp_w = water temp
# c = temperature coefficient = 0.7 or could do sensitivity testing on that as well

# are we interested in the daily change in temp or just the daily temp ignoring previous day?



water_temp = function(water, ambient, bathtub_df, input_year){
  
  water_df <- water %>% 
    filter(year == input_year) 
  
  air_df <- ambient %>% 
    filter(year == input_year) 
  
  temp_df <- data.frame(date = bathtub_df$date,
                        day = bathtub_df$day,
                        month = bathtub_df$month,
                        year = bathtub_df$year,
                        flow = bathtub_df$flow_out_final,
                        temp_w = water_df$mean_water_temp_c,
                        temp_a = air_df$daily_max_temp_c,
                        temp_calc = NA,
                        c = NA)
  
  min_flow = bathtub_df %>% 
    select(flow_out_final) %>% 
    drop_na() %>% 
    mutate(flow_out_final = ifelse(flow_out_final<0, 0, flow_out_final)) %>% 
    mutate(min_flow = min(flow_out_final))
  
  max_flow = bathtub_df %>% 
    select(flow_out_final) %>% 
    drop_na() %>% 
    mutate(max_flow = max(flow_out_final))
  
  for(i in 1:nrow(temp_df)){
    temp_df$c[i] = 1 - ((temp_df$flow[i] - min_flow$min_flow[i])/(max_flow$max_flow[i] - min_flow$min_flow[i]))
  }
  
  for(i in 1:nrow(temp_df)){
    
    if(temp_df$temp_a[i] >= temp_df$temp_w[i]){
      temp_df$temp_calc[i] = (temp_df$temp_a[i]*temp_df$c[i])+temp_df$temp_w[i]
    }
      
      
    if(temp_df$temp_w[i] > temp_df$temp_a[i]){
      temp_df$temp_calc[i] = temp_df$temp_w[i]
    }

  }
  
  for(i in 2:nrow(temp_df)){
    if(temp_df$flow[i] <= 0){
      temp_df$temp_calc[i] = NA
    }
  }
  return(temp_df)

  }


 
#can we build water volume into c? Maybe c changes with volume, smaller c means faster/more change in temp, larger c means less temp change 
# 
# 
# mutate(c = if(flow > (mean(flow)+sd(flow))){
#   0.6} 
#   else{
#     if((mean(flow)-sd(flow))<flow & flow<(mean(flow)+sd(flow))){
#       0.7
#     }
#     else{
#       0.8
#     }
#   }
# )

