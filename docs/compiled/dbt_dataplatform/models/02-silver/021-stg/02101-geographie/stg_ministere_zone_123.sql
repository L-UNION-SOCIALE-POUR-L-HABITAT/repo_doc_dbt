/**
 *
 * Description :    Alimentation de la table staging stg_ministere_zone_123
 *                  Renommage, nettoyage, typage
 * Fréquence :      Annuel
 * Mode :           Insert/update
 * Source:          raw_ministere_zone_123
 * Cible :          stg_ministere_zone_123
 */




with

-------------------------------------------------------------------
--******************* RENOMMAGE DES COLONNES **********************
-------------------------------------------------------------------
 cte_rename_raw_ministere_zone_123 as 
 (
    select 
        [CODGEO]                  as commune_code,
        [ZONE]                    as zone_123_code
      
    from   "wh_dp_bronze"."raw"."raw_ministere_zone_123"
 ),


-------------------------------------------------------------------
--************* TYPAGE DES COLONNES ******************
-------------------------------------------------------------------

cte_finale as
(
    select 
        commune_code
        , isnull(zone_123_code,'N/A')   as zone_123_code
        , 
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Romance Standard Time' AS datetime2(3))
 as _meta_loaded_at

    from cte_rename_raw_ministere_zone_123
)

-------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------
select 
    *
from 
    cte_finale