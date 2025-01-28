bagsTable = 'inventory'
quantum.prepare('quantum_inventory:getBag', 'select * from '..bagsTable..' where bag_type = @bag_type')
quantum.prepare('quantum_inventory:insertBag', 'insert into '..bagsTable..' (slots, bag_type, weight) values (@slots, @bag_type, @weight)')
quantum.prepare('quantum_inventory:updateBag', 'insert into '..bagsTable..' (slots, bag_type) values (@slots, @bag_type) on duplicate key update slots = @slots')
quantum.prepare('quantum_inventory:updateBagWeight', 'update '..bagsTable..' set weight = @weight where bag_type = @bag_type')
quantum.prepare('quantum_inventory:updateBagWithoutId', 'insert into '..bagsTable..' (slots, bag_type) values (@slots, @bag_type) on duplicate key update slots = @slots')
quantum.prepare('quantum_inventory:deleteBag', 'delete from '..bagsTable..' where bag_type = @bag_type')