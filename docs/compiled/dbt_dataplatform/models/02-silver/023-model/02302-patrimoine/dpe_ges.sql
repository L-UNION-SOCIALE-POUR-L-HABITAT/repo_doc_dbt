/**
 *
 * Description :    Alimentation de la table dpe_ges
 * Fréquence :      Annuel
 * Mode :           Annule et remplace
 * Source:          ref_dataplatform
 * Cible :          dpe_ges
 */




    
    
    
    select
        code as dpe_ges_code,
        libelle as dpe_ges_libelle,
        
     
        HASHBYTES('SHA2_256', 
    
        cast(code as varchar(max))
    
)  
 
 as dpe_ges_hk,
        
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Romance Standard Time' AS datetime2(3))
 as _meta_loaded_at
    from "wh_dp_bronze"."seed"."ref_dataplatform"
    where objet = 'dpe_ges'
    
    union all

    select
        'N/A' as dpe_ges_code,
        'Non disponible' as dpe_ges_libelle,
        
     
        HASHBYTES('SHA2_256', 
    
        cast('N/A' as varchar(max))
    
)  
 
 as dpe_ges_hk,
        
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Romance Standard Time' AS datetime2(3))
 as _meta_loaded_at
