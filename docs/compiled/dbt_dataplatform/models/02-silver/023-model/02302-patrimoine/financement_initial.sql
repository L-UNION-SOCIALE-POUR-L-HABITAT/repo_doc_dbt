/**
 *
 * Description :    Alimentation de la table financement_initial
 * Fréquence :      Annuel
 * Mode :           Annule et remplace
 * Source:          ref_dataplatform
 * Cible :          financement_initial
 */




    
    
    
    select
        code as financement_initial_code,
        libelle as financement_initial_libelle,
        
     
        HASHBYTES('SHA2_256', 
    
        cast(code as varchar(max))
    
)  
 
 as financement_initial_hk,
        
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Romance Standard Time' AS datetime2(3))
 as _meta_loaded_at
    from "wh_dp_bronze"."seed"."ref_dataplatform"
    where objet = 'financement_initial'
    
    union all

    select
        'N/A' as financement_initial_code,
        'Non disponible' as financement_initial_libelle,
        
     
        HASHBYTES('SHA2_256', 
    
        cast('N/A' as varchar(max))
    
)  
 
 as financement_initial_hk,
        
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Romance Standard Time' AS datetime2(3))
 as _meta_loaded_at
