/**
 *
 * Description :    Alimentation de la table staging stg_ministere_zone_abc
 *                  Renommage, nettoyage, typage
 * Fréquence :      Annuel
 * Mode :           Insert/update
 * Source:          raw_ministere_zone_abc
 * Cible :          stg_ministere_zone_abc
 */




with

-------------------------------------------------------------------
--******************* RENOMMAGE DES COLONNES **********************
-------------------------------------------------------------------
 cte_rename_raw_ministere_zone_abc as 
 (
    select 
        [CODGEO]                  as commune_code,
        [ZONE]                    as zone_abc_code
      
    from   "wh_dp_bronze"."raw"."raw_ministere_zone_abc"
 ),


-------------------------------------------------------------------
--************* TYPAGE DES COLONNES ******************
-------------------------------------------------------------------

cte_finale as
(
    select 
        commune_code
        , isnull(zone_abc_code,'N/A')   as zone_abc_code
        , 
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Romance Standard Time' AS datetime2(3))
 as _meta_loaded_at

    from cte_rename_raw_ministere_zone_abc
)

-------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------
select 
    *
from 
    cte_finale