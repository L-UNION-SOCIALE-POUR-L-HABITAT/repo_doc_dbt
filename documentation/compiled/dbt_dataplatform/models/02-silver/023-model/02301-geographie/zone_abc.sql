/**
 *
 * Description :    Alimentation de la table zone_abc
 * Fréquence :      Annuel
 * Mode :           Insert/update
 * Source:          int_zone_abc
 * Cible :          zone_abc
 */




    
    
    
    select
        code as zone_abc_code,
        libelle as zone_abc_libelle,
        
     
        HASHBYTES('SHA2_256', 
    
        cast(code as varchar(max))
    
)  
 
 as zone_abc_hk,
        
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Romance Standard Time' AS datetime2(3))
 as _meta_loaded_at
    from "wh_dp_bronze"."seed"."ref_dataplatform"
    where objet = 'zone_abc'
    
    union all

    select
        'N/A' as zone_abc_code,
        'Non disponible' as zone_abc_libelle,
        
     
        HASHBYTES('SHA2_256', 
    
        cast('N/A' as varchar(max))
    
)  
 
 as zone_abc_hk,
        
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Romance Standard Time' AS datetime2(3))
 as _meta_loaded_at
