/**
 *
 * Description :    Alimentation de la table epci
 * Fréquence :      Annuel
 * Mode :           Insert/update
 * Source:          zone_abc
 * Cible :          dim_zone_abc 
 */




with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
-- Sélection des colonnes 
cte_zone_abc as
(
    select 
        zone_abc_code,
        zone_abc_libelle
    
    from
        "wh_dp_silver"."dbo"."zone_abc"

),

-- Ajout des clés techniques (différentes de la couche silver car sans année )
cte_hk_zone_abc as
(
    select 
        *
        , 
     
        HASHBYTES('SHA2_256', 
    
        cast(zone_abc_code as varchar(max))
    
)  
 
       as zone_abc_hk
 

    from 
        cte_zone_abc
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
        cte_hk_zone_abc
)

-------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------
select 
    *
from 
    cte_finale