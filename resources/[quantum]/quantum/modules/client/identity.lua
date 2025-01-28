local registration_number = "00AAA000"

quantum.setRegistrationNumber = function(registration)
	registration_number = registration
end

quantum.getRegistrationNumber = function()
	return registration_number
end