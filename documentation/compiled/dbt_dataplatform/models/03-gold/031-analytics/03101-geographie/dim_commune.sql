/**
 *
 * Description :    Alimentation de la table dim_commune
 * Fréquence :      Annuel
 * Mode :           Insert/update
 * Source:          commune
 * Cible :          dim_commune
 */




with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
-- Sélection des colonnes 
cte_commune as
(
    select 
       
        commune_code,
        commune_libelle,
        commune_pays_libelle,
        departement_code,
        ept_code,
        epci_code,
        commune_annee,
        commune_annee_last_flag,
        zone_123_code,
        zone_abc_code,
        logements_prives_nombre
    
    from
        "wh_dp_silver"."dbo"."commune"

),

-- Application des filtres 
cte_filtered_commune as
(
    select 
       
        commune_code,
        commune_libelle,
        commune_pays_libelle,
        departement_code,
        ept_code,
        epci_code,
        commune_annee,
        zone_123_code,
        zone_abc_code,
        logements_prives_nombre

    from
        cte_commune
    where
        commune_annee_last_flag = 1
),

-- Ajout des clés techniques (différentes de la couche silver car sans année )
cte_hk_filtered_commune as
(
    select 
        *
        , 
     
        HASHBYTES('SHA2_256', 
    
        cast(commune_code as varchar(max))
    
)  
 
        as commune_hk
        , 
     
        HASHBYTES('SHA2_256', 
    
        cast(departement_code as varchar(max))
    
)  
 
    as departement_hk
        , 
     
        HASHBYTES('SHA2_256', 
    
        cast(ept_code as varchar(max))
    
)  
 
            as ept_hk
        , 
     
        HASHBYTES('SHA2_256', 
    
        cast(epci_code as varchar(max))
    
)  
 
           as epci_hk
        , 
     
        HASHBYTES('SHA2_256', 
    
        cast(zone_123_code as varchar(max))
    
)  
 
       as zone_123_hk
        , 
     
        HASHBYTES('SHA2_256', 
    
        cast(zone_abc_code as varchar(max))
    
)  
 
       as zone_abc_hk

    from 
        cte_filtered_commune
),

-- Ajout des champs techniques
cte_finale as
(
    select
        *
        , 
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Romance Standard Time' AS datetime2(3))
 as _meta_loaded_at
    from
        cte_hk_filtered_commune
)

-------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------
select 
    *
from 
    cte_finale