 SELECT mas.segment1,MAS.DESCRIPTION, MAS.ATTRIBUTE6, MAS.ATTRIBUTE7, mas.ATTRIBUTE20,mas.organization_id,com_mtl_system_items.SEGMENT1

     FROM apps.bom_bill_of_materials,
          apps.bom_inventory_components,
          apps.mtl_system_items_b mas,
          apps.mtl_system_items_b com_mtl_system_items
    WHERE (bom_inventory_components.bill_sequence_id =
              bom_bill_of_materials.bill_sequence_id)
          AND (bom_bill_of_materials.organization_id = mas.organization_id)
          AND (bom_bill_of_materials.assembly_item_id = mas.inventory_item_id)
          AND (bom_inventory_components.component_item_id =
                  com_mtl_system_items.inventory_item_id)
          AND (mas.organization_id = com_mtl_system_items.organization_id)
          AND bom_inventory_components.DISABLE_DATE IS NULL 
          AND com_mtl_system_items.SEGMENT1 IN ('HT000617', 'HT000628')
          AND mas.ATTRIBUTE_CATEGORY LIKE 'Finished Goods'
        AND mas.segment1 = '412051AC01';