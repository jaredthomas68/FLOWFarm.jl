import FlowFarm; const ff = FlowFarm

rotor_diameter = 40.0
hub_height = 90.0
yaw = 0.0
ct = 0.7 
cp = 0.8
generator_efficiency = 0.944
ai = 1.0/3.0
wind_speed = 8.1
air_density = 1.1716  # kg/m^3
turbine_x = [0.0]
turbine_y = [0.0]
turbine_z = [0.0]
turbine_yaw = [0.0]
turbine_ct = [ct]
turbine_ai = [ai]
winddirections = [270.0*pi/180.0]
windspeeds = [wind_speed]
windprobabilities = [1.0]
measurementheights = [hub_height]
shearexponent = 0.15
turbine_inflow_velcities = [wind_speed]

ct_model = ff.ConstantCt(ct)
power_model = ff.ConstantCp([cp], [generator_efficiency])
wind_shear_model = [ff.PowerLawWindShear(shearexponent)]

turbine1 = ff.Turbine(1, [rotor_diameter], [hub_height], [ct_model], [power_model])
turbine_definitions = [turbine1]
sorted_turbine_index = [1]

windfarm = ff.WindFarm(turbine_x, turbine_y, turbine_z, turbine_definitions)
windfarmstate = ff.SingleWindFarmState(1, turbine_x, turbine_y, turbine_z, turbine_yaw, turbine_ct, turbine_ai, sorted_turbine_index, turbine_inflow_velcities, [0.0])
windresource = ff.DiscretizedWindResource(winddirections, windspeeds, windprobabilities, measurementheights, air_density, wind_shear_model)

loc = [7.0*rotor_diameter, 0.0, hub_height]
alpha = 0.1
wakedeficitmodel = ff.JensenTopHat(alpha)
horizontal_spread_rate = alpha
wakedeflectionmodel = ff.JiminezYawDeflection(horizontal_spread_rate)
wakecombinationmodel = ff.SumOfSquaresFreestreamSuperposition()

ms1 = ff.WindFarmModelSet(wakedeficitmodel, wakedeflectionmodel, wakecombinationmodel)
pd1 = ff.WindFarmProblemDescription(windfarm, windresource, [windfarmstate])