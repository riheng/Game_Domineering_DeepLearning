require 'nn'

local inputs=torch.Tensor(11435,3,8,8)
local outputs=torch.Tensor(11435,1,8,8)
local csvFile = io.open('/home/zhu/Documents/data_csv/log.csv','r')
--local csvFile = io.open('/home/zhu/Documents/data_csv/symtr_upDown.csv','r')
--local csvFile = io.open('/home/zhu/Documents/data_csv/symtr_leftRight.csv','r')
--local csvFile = io.open('/home/zhu/Documents/data_csv/symtr_upDown_leftRight.csv','r')

print("Read file")
i = 0

for line in csvFile:lines('*l') do
    i = i+1
    j = 1
    k = 1
    l = 1
    local ligne = line:split(',')
z
    for key, val in ipairs(ligne) do
        v = tonumber (val)

	if j < 4 then
	    inputs[i][j][k][l] = v
	else
	    outputs[i][1][k][l] = v
	end	


	l = l+1
	if l > 8 then
	    l = 1
	    k = k +1
	end


	if k > 8 then
	    j = j+1
	    l = 1
	    k = 1
	end

    end
end


torch.save("/home/zhu/Documents/data_dat/inputs.dat", inputs)
torch.save("/home/zhu/Documents/data_dat/outputs.dat", outputs)

--torch.save("/home/zhu/Documents/data_dat/inputs_upDown.dat", inputs)
--torch.save("/home/zhu/Documents/data_dat/outputs_upDown.dat", outputs)

--torch.save("/home/zhu/Documents/data_dat/inputs_leftRight.dat", inputs)
--torch.save("/home/zhu/Documents/data_dat/outputs_leftRight.dat", outputs)

--torch.save("/home/zhu/Documents/data_dat/inputs_upDown_leftRight.dat", inputs)
--torch.save("/home/zhu/Documents/data_dat/outputs_upDown_leftRight.dat", outputs)

print("success. end")
