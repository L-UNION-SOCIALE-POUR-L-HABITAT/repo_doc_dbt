/**
 *
 * Description :    Alimentation de la table epci
 * Fréquence :      Annuel
 * Mode :           Insert/update
 * Source:          zone_123
 * Cible :          dim_zone_123 
 */




with

-------------------------------------------------------------------
--*********************** TABLE EN ENTREE *************************
-------------------------------------------------------------------
-- Sélection des colonnes 
cte_zone_123 as
(
    select 
        zone_123_code,
        zone_123_libelle
    
    from
        "wh_dp_silver"."dbo"."zone_123"

),

-- Ajout des clés techniques (différentes de la couche silver car sans année )
cte_hk_zone_123 as
(
    select 
        *
        , 
     
        HASHBYTES('SHA2_256', 
    
        cast(zone_123_code as varchar(max))
    
)  
 
       as zone_123_hk
 

    from 
        cte_zone_123
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
        cte_hk_zone_123
)

-------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------
select 
    *
from 
    cte_finale