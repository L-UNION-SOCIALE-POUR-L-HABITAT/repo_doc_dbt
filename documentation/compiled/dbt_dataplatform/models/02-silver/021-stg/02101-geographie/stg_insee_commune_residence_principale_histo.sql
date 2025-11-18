/**
 *
 * Description :    Alimentation de la table staging stg_insee_commune_residence_principale_histo
 *                  Renommage, nettoyage, typage
 * Fréquence :      Annuel
 * Mode :           Insert/update
 * Source:          raw_insee_commune_residence_principale_histo
 * Cible :          stg_insee_commune_residence_principale_histo
 */




with

-------------------------------------------------------------------
--******************* RENOMMAGE DES COLONNES **********************
-------------------------------------------------------------------
 cte_rename_raw_insee_commune_residence_principale_histo as 
 (
    select 
        [CODGEO]                 as commune_code,
        [LIBGEO]                 as commune_libelle,
        [AN]                     as commune_annee,
        [P_LOG]                  as logements_prives_nombre
      
      from   "wh_dp_bronze"."raw"."raw_insee_commune_residence_principale_histo"
 ),


-------------------------------------------------------------------
--************* TYPAGE DES COLONNES ******************
-------------------------------------------------------------------

cte_finale as
(
    select 
        commune_code,
        commune_libelle,
        commune_annee,
        
    case
        -- Valeurs nulles ou codes à ignorer
        when logements_prives_nombre is null 
          or logements_prives_nombre in ('999', 'NA') 
        then CAST(NULL AS INTEGER)

        -- Cas où la valeur peut être castée directement en entier
        when try_cast(logements_prives_nombre as integer) is not null 
        then cast(logements_prives_nombre as integer)

        -- Cas où la valeur est au format scientifique (ex: '1.1144e+006')
        when try_cast(logements_prives_nombre as float) is not null 
        then cast(cast(logements_prives_nombre as float) as integer)

        -- Sinon, valeur par défaut
        else CAST(NULL AS INTEGER)
    end
    as logements_prives_nombre,
        
    CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'Romance Standard Time' AS datetime2(3))
                               as _meta_loaded_at

    from cte_rename_raw_insee_commune_residence_principale_histo
)

-------------------------------------------------------------------
--************************ ETAPE FINALE **************************
-------------------------------------------------------------------
select 
    *
from 
    cte_finale