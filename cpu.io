### Reference IO planning design
<br>
(globals 
    version = 3 
    io_order = default 
) 

(iopad 
    (bottom 
        (inst name ="pc3d01_1" space = 100 place_status=fixed) 
        (inst name ="pc3d01_3" space = 100 place_status=fixed) 
        (inst name ="pc3d01_4" space = 100 place_status=fixed) 
        (inst name ="pc3d01_5" space = 100 place_status=fixed) 
         (inst name ="pvdi_VDD_CORE_5" space = 100 place_status=fixed) 
        (inst name ="pv0i_VSS_CORE_5" space = 100 place_status=fixed) 
        (inst name ="pvda_VDDO_CORE_5" space = 100 place_status=fixed) 
        (inst name ="pv0a_VSSO_CORE_5" space = 100 place_status=fixed) 
        (inst name ="pc3d01_6" space = 100 place_status=fixed) 
        (inst name ="pc3d01_7" space = 100 place_status=fixed) 
        (inst name ="pc3d01_8" space = 100 place_status=fixed) 
        (inst name ="pc3d01_10" space = 100 place_status=fixed) 
        (inst name ="pc3d01_11" space = 100 place_status=fixed) 
        (inst name ="pvdi_VDD_CORE_1" space = 100 place_status=fixed) 
        (inst name ="pv0i_VSS_CORE_1" space = 100 place_status=fixed) 
        (inst name ="pvda_VDDO_CORE_1" space = 100 place_status=fixed) 
        (inst name ="pv0a_VSSO_CORE_1" space = 100 place_status=fixed) 
    ) 

    (right 
        (inst name ="pc3d01_12" space = 100 place_status=fixed) 
        (inst name ="pc3d01_13" space = 100 place_status=fixed) 
        (inst name ="pc3d01_14" space = 100 place_status=fixed) 
        (inst name ="pc3d01_15" space = 100 place_status=fixed) 
         (inst name ="pvdi_VDD_CORE_7" space = 100 place_status=fixed) 
        (inst name ="pv0i_VSS_CORE_7" space = 100 place_status=fixed) 
        (inst name ="pvda_VDDO_CORE_7" space = 100 place_status=fixed) 
        (inst name ="pv0a_VSSO_CORE_7" space = 100 place_status=fixed) 
        (inst name ="pc3d01_16" space = 100 place_status=fixed) 
        (inst name ="pc3d01_17" space = 100 place_status=fixed) 
        (inst name ="pc3d01_18" space = 100 place_status=fixed) 
        (inst name ="pc3d01_19" space = 100 place_status=fixed) 
        (inst name ="pc3d01_20" space = 100 place_status=fixed) 
        (inst name ="pvdi_VDD_CORE_2" space = 100 place_status=fixed) 
        (inst name ="pv0i_VSS_CORE_2" space = 100 place_status=fixed) 
        (inst name ="pvda_VDDO_CORE_2" space = 100 place_status=fixed) 
        (inst name ="pv0a_VSSO_CORE_2" space = 100 place_status=fixed) 
    ) 

    (top 
        (inst name ="pc3c01_1" space = 100 place_status=fixed)
        (inst name ="pc3o05_1" space = 100 place_status=fixed) 
        (inst name ="pc3o05_2" space = 100 place_status=fixed) 
        (inst name ="pc3o05_3" space = 100 place_status=fixed) 
         (inst name ="pvdi_VDD_CORE_6" space = 100 place_status=fixed) 
        (inst name ="pv0i_VSS_CORE_6" space = 100 place_status=fixed) 
        (inst name ="pvda_VDDO_CORE_6" space = 100 place_status=fixed) 
        (inst name ="pv0a_VSSO_CORE_6" space = 100 place_status=fixed) 
        (inst name ="pc3o05_4" space = 100 place_status=fixed) 
        (inst name ="pc3o05_5" space = 100 place_status=fixed) 
        (inst name ="pc3o05_6" space = 100 place_status=fixed) 
        (inst name ="pc3o05_7" space = 100 place_status=fixed) 
        (inst name ="pc3o05_8" space = 100 place_status=fixed)
        (inst name ="pvdi_VDD_CORE_3" space = 100 place_status=fixed) 
        (inst name ="pv0i_VSS_CORE_3" space = 100 place_status=fixed) 
        (inst name ="pvda_VDDO_CORE_3" space = 100 place_status=fixed) 
        (inst name ="pv0a_VSSO_CORE_3" space = 100 place_status=fixed) 
    ) 

    (left 
	(inst name ="pc3o05_9" space = 100 place_status=fixed) 
        (inst name ="pc3o05_10" space = 100 place_status=fixed) 
        (inst name ="pc3o05_11" space = 100 place_status=fixed)
        (inst name ="pvdi_VDD_CORE_4" space = 100 place_status=fixed) 
        (inst name ="pv0i_VSS_CORE_4" space = 100 place_status=fixed) 
        (inst name ="pvda_VDDO_CORE_4" space = 100 place_status=fixed) 
        (inst name ="pv0a_VSSO_CORE_4" space = 100 place_status=fixed) 
        (inst name ="pc3o05_122222222" space = 100 place_status=fixed)
         (inst name ="pvdi_VDD_CORE_8" space = 100 place_status=fixed) 
        (inst name ="pv0i_VSS_CORE_8" space = 100 place_status=fixed) 
        (inst name ="pvda_VDDO_CORE_8" space = 100 place_status=fixed) 
        (inst name ="pv0a_VSSO_CORE_8" space = 100 place_status=fixed) 
    ) 

    
    (topright 
        (inst name="corner_3" cell = pfrelr place_status = fixed orientation = R90) 
    ) 
    (topleft 
        (inst name="corner_4" cell = pfrelr place_status = fixed orientation = R180) 
    ) 
    (bottomright 
        (inst name="corner_2" cell = pfrelr place_status = fixed orientation = R0) 
    ) 
    (bottomleft 
        (inst name="corner_1" cell = pfrelr place_status = fixed orientation = R2100) 
    ) 
)

