/**
 *
 * Description :    Alimentation de la table dim_ept
 * Fréquence :      Annuel
 * Mode :           Insert/update
 * Source:          ept
 * Cible :          dim_ept 
 */




with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
-- Sélection des colonnes 
cte_ept as
(
    select 
        ept_code,
        ept_libelle,
       -- epci_code,
        ept_annee_last_flag
    
    from
        "wh_dp_silver"."dbo"."ept"

),

-- Application des filtres 
cte_filtered_ept as
(
    select 
        ept_code,
        ept_libelle
       -- epci_code

    from
        cte_ept
    where
        ept_annee_last_flag = 1
),

-- Ajout des clés techniques (différentes de la couche silver car sans année )
cte_hk_filtered_ept as
(
    select 
        *
        , 
     
        HASHBYTES('SHA2_256', 
    
        cast(ept_code as varchar(max))
    
)  
 
       as ept_hk
 

    from 
        cte_filtered_ept
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
        cte_hk_filtered_ept
)

-------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------
select 
    *
from 
    cte_finale