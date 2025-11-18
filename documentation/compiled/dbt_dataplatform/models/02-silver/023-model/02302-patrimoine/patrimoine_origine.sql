/**
 *
 * Description :    Alimentation de la table patrimoine_origine
 * Fréquence :      Annuel
 * Mode :           Annule et remplace
 * Source:          ref_dataplatform
 * Cible :          patrimoine_origine
 */




    
    
    
    select
        code as patrimoine_origine_code,
        libelle as patrimoine_origine_libelle,
        
     
        HASHBYTES('SHA2_256', 
    
        cast(code as varchar(max))
    
)  
 
 as patrimoine_origine_hk,
        
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Romance Standard Time' AS datetime2(3))
 as _meta_loaded_at
    from "wh_dp_bronze"."seed"."ref_dataplatform"
    where objet = 'patrimoine_origine'
    
    union all

    select
        'N/A' as patrimoine_origine_code,
        'Non disponible' as patrimoine_origine_libelle,
        
     
        HASHBYTES('SHA2_256', 
    
        cast('N/A' as varchar(max))
    
)  
 
 as patrimoine_origine_hk,
        
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Romance Standard Time' AS datetime2(3))
 as _meta_loaded_at
