#fix locations with spaces----------------------------------------------------------------------------------
    #python seems to like spaces and hate ''
    #docker hates spades and needs ''
origin = origin.replace("\'",'').replace("\"",'')
counter = 0
for i in location_m: 
    if i == ' ':
        space = counter
        #first part of string
        str1 = location_m[:counter]
        i1 = str1.rfind('/')                #index of last '/' in the string before the space
        str1 = str1[:i1]+"\'"+str1[i1:]     #add ' after last '/'
        #second part of string
        str2 = location_m[counter:]
        i2 = str2.find('/')                 #index of the first '/' in the string after the space
        str2 = str2[:i2]+"\'"+str2[i2:]     #add ' after first '/'
        #redefine location_m
        location_m = str1+str2
    counter +=1
print(location_m)
        
#-----------------------------------------------------------------------------------------------------------