/**
 *
 * Description :    Alimentation de la table zone_123
 * Fréquence :      Annuel
 * Mode :           Insert/update
 * Source:          ref_dataplatform
 * Cible :          zone_123
 */





    
    
    
    select
        code as zone_123_code,
        libelle as zone_123_libelle,
        
     
        HASHBYTES('SHA2_256', 
    
        cast(code as varchar(max))
    
)  
 
 as zone_123_hk,
        
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Romance Standard Time' AS datetime2(3))
 as _meta_loaded_at
    from "wh_dp_bronze"."seed"."ref_dataplatform"
    where objet = 'zone_123'
    
    union all

    select
        'N/A' as zone_123_code,
        'Non disponible' as zone_123_libelle,
        
     
        HASHBYTES('SHA2_256', 
    
        cast('N/A' as varchar(max))
    
)  
 
 as zone_123_hk,
        
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Romance Standard Time' AS datetime2(3))
 as _meta_loaded_at
