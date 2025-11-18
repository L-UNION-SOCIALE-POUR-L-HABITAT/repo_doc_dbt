/**
 *
 * Description :    Alimentation de la table epci_nature
 * Fréquence :      Annuel
 * Mode :           Insert/update
 * Source:          ref_dataplatform
 * Cible :          epci_nature
 */





    
    
    
    select
        code as epci_nature_code,
        libelle as epci_nature_libelle,
        
     
        HASHBYTES('SHA2_256', 
    
        cast(code as varchar(max))
    
)  
 
 as epci_nature_hk,
        
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Romance Standard Time' AS datetime2(3))
 as _meta_loaded_at
    from "wh_dp_bronze"."seed"."ref_dataplatform"
    where objet = 'epci_nature'
    
    union all

    select
        'N/A' as epci_nature_code,
        'Non disponible' as epci_nature_libelle,
        
     
        HASHBYTES('SHA2_256', 
    
        cast('N/A' as varchar(max))
    
)  
 
 as epci_nature_hk,
        
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Romance Standard Time' AS datetime2(3))
 as _meta_loaded_at
