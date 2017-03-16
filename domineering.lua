require 'nn'

local inputs=torch.Tensor(10000,3,8,8)
local outputs=torch.Tensor(10000,1,8,8)
local csvFile=io.open('domineering.csv','r')
local count=0

for line in csvFile:lines('*l') do	
	local l =line:split(',')
	count =count +1
	if count <=10000 then

		for key,val in ipairs(l) do
			v=tonumber(val)
			if key<=64 then
				a=torch.floor(key/8)+1
				
				b=key-torch.floor(key/8)*8
				if b==0 then
					b=8
					a=a-1
				end	
				if count>=19900 then	
				end	
				inputs[count][1][a][b]=v
			end
			
			if key >64 and key<=128 then
				a=torch.floor(key/8)-7
				b=key-torch.floor(key/8)*8
				if b==0 then
					b=8
					a=a-1
				end
				inputs[count][2][a][b]=v
			end

			if key >128 and key<=192 then
				a=torch.floor(key/8)-15
				b=key-torch.floor(key/8)*8
				if b==0 then
					b=8
					a=a-1
				end
				inputs[count][3][a][b]=v
			end
			
			if key >192  then
				a=torch.floor(key/8)-23
				b=key-torch.floor(key/8)*8
				if b==0 then
					b=8
					a=a-1
				end
				outputs[count][1][a][b]=v
			end
	end
	end
end
 
net = nn.Sequential()
couche1 = nn.SpatialConvolution(3, 64, 3, 3, 1, 1, 1, 1)
net:add(couche1)
net:add(nn.ReLU())
net:add(nn.SpatialConvolution(64, 64, 3, 3, 1, 1, 1, 1))
net:add(nn.ReLU())
net:add(nn.SpatialConvolution(64, 64, 3, 3, 1, 1, 1, 1))
net:add(nn.ReLU())
net:add(nn.SpatialConvolution(64, 64, 3, 3, 1, 1, 1, 1))
net:add(nn.ReLU())
net:add(nn.SpatialConvolution(64, 64, 3, 3, 1, 1, 1, 1))
net:add(nn.ReLU())
net:add(nn.SpatialConvolution(64, 64, 3, 3, 1, 1, 1, 1))
net:add(nn.ReLU())
couche2 = nn.SpatialConvolution(64, 1, 3, 3, 1, 1, 1, 1)
net:add(couche2)
net:add(nn.View(64))
net:add(nn.SoftMax())
net:add(nn.View(8, 8))


taille = inputs:size()
n_ligne = taille[1]

-- Define an evaluation function,inside our training loop
-- use optim.sgd to run training.

require 'optim'

local function feval(params)
	gradParams:zero()
	local outputs = model:forward(batchInputs)
	local loss = criterion:forward(outputs, batchLabels)
	local dloss_doutput = criterion:backward(outputs, batchLabels)
	model:backward(batchInputs, dloss_doutput)
	return loss,gradParams
end


criterion = nn.MSECriterion()
for k = 1, 1 do
    print('Epoch', k)
    local indice_rand = torch.randperm(n_ligne)
    print('Apprentissage')
    for i = 1, 2 * n_ligne / 3 do
        indice = indice_rand[i]
        out = net:forward(inputs[indice])

        err = criterion:forward(out, outputs[indice])
        --print(err)
        net:backward(inputs[indice],criterion:backward(net.output, outputs[indice]))
        net:updateParameters(0.2)
        net:zeroGradParameters()
    end
    --calcul de l'erreur moyenne en test
    print("Calcul de l'erreur moyenne en test")
    local erreur_test = 0
    for i = 2 * n_ligne / 3 + 1, n_ligne do
        indice = indice_rand[i]
        out = net:forward(inputs[indice])
        err = criterion:forward(out, outputs[indice])
        erreur_test = erreur_test + err
    end
    print(erreur_test / (n_ligne / 3))
end




