/**
 *
 * Description :    Alimentation de la table reservation_contingent
 * Fréquence :      Annuel
 * Mode :           Annule et remplace
 * Source:          ref_dataplatform
 * Cible :          reservation_contingent
 */




    
    
    
    select
        code as reservation_contingent_code,
        libelle as reservation_contingent_libelle,
        
     
        HASHBYTES('SHA2_256', 
    
        cast(code as varchar(max))
    
)  
 
 as reservation_contingent_hk,
        
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Romance Standard Time' AS datetime2(3))
 as _meta_loaded_at
    from "wh_dp_bronze"."seed"."ref_dataplatform"
    where objet = 'reservation_contingent'
    
    union all

    select
        'N/A' as reservation_contingent_code,
        'Non disponible' as reservation_contingent_libelle,
        
     
        HASHBYTES('SHA2_256', 
    
        cast('N/A' as varchar(max))
    
)  
 
 as reservation_contingent_hk,
        
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Romance Standard Time' AS datetime2(3))
 as _meta_loaded_at
